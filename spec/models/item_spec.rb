require 'rails_helper'

def clear_db
  Item.destroy_all
  ItemBase.destroy_all
  Supplier.destroy_all
  Attrib.destroy_all
end

def create_seed_data
  @supplier = Supplier.create(name: "Supplier_1")


  @attrib = { 
    color:     Attrib.create!(name: 'Color',     display_number: 3),
    thickness: Attrib.create!(name: 'Thickness', display_number: 1),
    size:      Attrib.create!(name: 'Size',      display_number: 2),
    model:     Attrib.create!(name: 'Model',     display_number: 4)
  }

  @basic_item = Item.new(item_base_name: "Test Product", supplier: @supplier, unit: "piece")
end

RSpec.describe Item, :type => :model do
  before(:each) do
    clear_db

    #After clearing the db, verify that the child tables are also cleared
    expect(AttribItemValue.all.count).to eq 0
    expect(AttribItemBase.all.count).to eq 0

    create_seed_data
  end

  describe "association", :assoc do
    describe "Attrib actively used by an Item" do
      it "errors on destroy" do
        @basic_item.add_attrib(@attrib[:color], "Red")
        @basic_item.save!
        expect { @attrib[:color].destroy!}.to raise_error
        expect(@attrib[:color].errors.messages[:base].first).to eq "Cannot delete record because dependent items exist"
      end
    end 

    describe "ItemBase" do 
      before(:each) do
        @supplier_a = Supplier.create(name: "Supplier_a")
        @supplier_b = Supplier.create(name: "Supplier_b")


        @item1 = Item.new(item_base_name: "EVA", supplier: @supplier_a, unit: "sheet")
        @item1.add_attrib(@attrib[:thickness], "7mm")
        @item1.add_attrib(@attrib[:color], "Black")
        @item1.add_attrib(@attrib[:model], "Linso")
        @item1.save!

        @item2 = Item.new(item_base_name: "EVA", supplier: @supplier_b, unit: "sheet")
        @item2.copy_attribs(@item1)
        @item2.save!

        @item3 = Item.new(item_base_name: "EVA", supplier: @supplier_b, unit: "truck")
        @item3.copy_attribs(@item1)
        @item3.add_attrib(@attrib[:color], "White")        
        @item3.save!

        @item_base = ItemBase.find_by_name("EVA")
      end

      describe "mapping" do
        before(:each) do
            @supplier_c = Supplier.create(name: "Supplier_c")
            @item4 = Item.new(item_base_name: "EVA", supplier: @supplier_c, unit: "sheet")
            @item4.copy_attribs(@item1)
            @item4.add_attrib(@attrib[:size], "Long")        
            @item4.save!
        end

        describe "by attrib then supplier", :attrib_then_supplier do
        # "Thickness": { "Supplier_a": ["7mm"], "Supplier_b": ["7mm"]}, ...
        # "Color": { "Supplier_a": ["Black"], "Supplier_b": ["White"] }, ...
        # ...
          before(:each) do
            @map = @item_base.map_by_attrib_then_supplier

            #This block is not used --START
            @supplier_b_attribs = {}
            @map.each do |attrib_name, supplier_map|
              @supplier_b_attribs[attrib_name] = supplier_map[@supplier_b.name]
            end
            #puts "Testing: #{@supplier_b_attribs}"
            #This block is not used --END

          end

          it "maps attribs" do
            #The number of attribs == the item with most attrib
            max = @item4.attrib_values.size + 1 #item attribs + unit
            expect(@map.size).to eq max
          end

          it "joins similar attrib values" do
            #puts "Thickness : #{@map["Thickness"]}"
            expect(@map["Thickness"][@supplier_b.name].size).to eq 1
          end

          it "stores unit info" do
            supplier_b_units = @map[:unit][@supplier_b.name]
            expect(supplier_b_units.size).to eq 2
            expect(supplier_b_units.include?("truck")).to be_truthy
          end

          it "stores size info" do
            supplier_b_size = @map["Size"][@supplier_b.name]
            expect(supplier_b_size).to eq nil

            supplier_c_size = @map["Size"][@supplier_c.name]
            expect(supplier_c_size.include?("Long")).to be_truthy
          end
        end

        describe "by supplier" do
          before(:each) do
            @map = @item_base.map_by_supplier
          end

          it "has correct count" do
            expect(@map.size).to eq 3 
          end

          it "each has correct attrib count" do
            item1_attribs = @item1.attrib_values.size + 2 #item1 attribs + supplier + unit
            item4_attribs = @item4.attrib_values.size + 2 #item4 attribs + supplier + unit

            puts "supplier_a: #{@map[@supplier_a.name]}"
            expect(@map[@supplier_a.name].size).to eq item1_attribs
            expect(@map[@supplier_c.name].size).to eq item4_attribs
            expect(@map[@supplier_c.name]["Size"].first).to eq "Long"
          end
        end
      end

      #Probably not usefule to use a shared example group for this.
      #Just experimenting :P
      describe "standard map", :std do
        it_should_behave_like "a standard map" do
          let(:method) { :map }
        end 
      end

    end
  end

  describe "create" do
    describe "Errors on Required fields" do
      it "raises an error when no Supplier and ItemBase" do
        expect { Item.create! }.to raise_error
      end
      it "raises an error when no ItemBase" do
        expect { Item.create!(supplier: @supplier, item_base: nil, unit: "piece") }.to raise_error
      end

      it "raises an error when no Supplier" do
        item_base = ItemBase.create(name: "ItemBase1")
        expect { Item.create!(supplier: nil, item_base: item_base, unit: "piece") }.to raise_error
      end
    end

    it "Auto creates ItemBase and Attribs", :auto do

      base_attribs = [AttribItemValue.new(attrib: @attrib[:color], value: "Red")]
      base_attribs << AttribItemValue.new(attrib: @attrib[:thickness], value: "1/2")

      item = Item.new(item_base_name: "Test Product", supplier: @supplier, unit: "piece")
      item.attrib_values << base_attribs
      item.save!

      reloaded = item.reload
      expect(reloaded.attrib_values.count).to eq(base_attribs.size)
      expect(reloaded.item_base.name).to eq(item.item_base_name)
      expect(reloaded.item_base.attribs.count).to eq(base_attribs.size)

    end

    describe "name" do
      before(:each) do
        @basic_item.add_attrib(@attrib[:color], "Red")
        @basic_item.add_attrib(@attrib[:size], "Small")
        @basic_item.add_attrib(@attrib[:thickness], "1/2")
        
        @item2 = Item.new(item_base_name: @basic_item.item_base.name, supplier: @supplier, unit: "piece")
        @item2.add_attrib(@attrib[:color], "Red")
        @item2.add_attrib(@attrib[:size], "Small")
        @item2.add_attrib(@attrib[:thickness], "1/2")
      end

      it "created even if item has no attribs" do
        item = Item.new(item_base_name: "Test Product", supplier: @supplier, unit: "piece")
        item.save!
        expect(item.name).to eq ("Test Product")
      end

      it "auto-updates when Attrib display_number is changed", :attrib_change do
        #Create 2 Items...
        @basic_item.save!
        @item2.attrib_values.last.value = "1/4"
        @item2.save!

        #Update the display number of the color Attrib...
        @attrib[:color].display_number = 0
        @attrib[:color].save!

        #Verify that the item names has changed
        expect(@basic_item.reload.name).to eq "Test Product Red 1/2 Small"
        expect(@item2.reload.name).to eq "Test Product Red 1/4 Small"

      end

      it "changes for different attrib values" do
        @basic_item.save!

        @item2.attrib_values.last.value = "1/4"
        @item2.save!

        expect(@basic_item.name).to eq("Test Product 1/2 Small Red")
        expect(@item2.name).to eq("Test Product 1/4 Small Red")
      end

      it "errors on duplicate" do
        @basic_item.save!
        expect { @item2.save! }.to raise_error
        expect(@item2.errors.messages[:base].first).to eq "Supplier_1, 'Test Product 1/2 Small Red piece' already exists."
      end

      it "detects duplicates due to spacing" do
        @basic_item.add_attrib(@attrib[:model], "R2 D2")
        @basic_item.save!

        @item2.add_attrib(@attrib[:model], "R2    D2")
        @item2.save
        expect(@item2.errors.messages[:base].first).to eq "Supplier_1, 'Test Product 1/2 Small Red R2 D2 piece' already exists."
      end

      it "detects duplicates even with difference case" do
        @basic_item.add_attrib(@attrib[:model], "r2 d2")
        @basic_item.save!

        @item2.attrib_values.clear
        @item2.add_attrib(@attrib[:model], "R2    D2")
        @item2.add_attrib(@attrib[:color], "rED")
        @item2.add_attrib(@attrib[:size], "sMALL")
        @item2.add_attrib(@attrib[:thickness], "1/2")
        @item2.save
        expect(@item2.errors.messages[:base].first).to eq "Supplier_1, 'Test Product 1/2 Small Red R2 D2 piece' already exists."
      end

      it "does not error with different unit" do
        @basic_item.save!
        @item2.unit = "meter"
        expect { @item2.save! }.not_to raise_error
      end

      it "does not error with different supplier", :supplier do
        @basic_item.save!
        @item2.supplier = Supplier.find_or_create_by(name: "Supplier_2")
        expect { @item2.save! }.not_to raise_error
      end
    end
  end
end

