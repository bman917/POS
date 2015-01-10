shared_examples "attrib map" do |expected_count|

    it "attribs has correct count" do      
      count = @item1.attrib_values.size + 2 #item attribs + supplier + unit
      expect(@map.size).to eq expected_count[:max_attribs]
    end

    it "joins similar attrib values" do
      # puts "Thickness: #{@map["Thickness"].to_a}"
      expect(@map["Thickness"].size).to eq expected_count[:thickness]
    end

    it "stores different attribs" do
      # puts "Color: #{@map["Color"].to_a}"
      expect(@map["Color"].size).to eq expected_count[:color]
    end

    it "stores supplier info" do
      # puts "Supplier: #{@map[:supplier].to_a}"
      expect(@map[:supplier].size).to eq expected_count[:supplier]
    end

    it "stores unit info" do
      expect(@map[:unit].size).to eq expected_count[:unit]
      included[:unit].each do | unit |
        expect(@map[:unit].include?(unit)).to be_truthy
      end
    end
    
end




shared_examples "a standard map" do
    before(:each) do
      item_spec_clear_db
      item_spec_create_seed_data
      @map = @item_base.send(method)
      puts "Testing Map: #{@map}"
    end


    it "attribs has correct count" do      
      count = @item1.attrib_values.size + 2 #item attribs + supplier + unit
      expect(@map.size).to eq count
    end

    it "joins similar attrib values" do
      # puts "Thickness: #{@map["Thickness"].to_a}"
      expect(@map["Thickness"].size).to eq 1
    end

    it "stores different attribs" do
      # puts "Color: #{@map["Color"].to_a}"
      expect(@map["Color"].size).to eq 2
    end

    it "stores supplier info" do
      # puts "Supplier: #{@map[:supplier].to_a}"
      expect(@map[:supplier].size).to eq 2
    end

    it "stores unit info" do
      expect(@map[:unit].size).to eq 2
      expect(@map[:unit].include?("truck")).to be_truthy
    end
end


def item_spec_clear_db
  Item.destroy_all
  ItemBase.destroy_all
  Supplier.destroy_all
  Attrib.destroy_all
end

def item_spec_create_seed_data
  @supplier = Supplier.create(name: "Supplier_1")
  @supplier_a = Supplier.create(name: "Supplier_a")
  @supplier_b = Supplier.create(name: "Supplier_b")


  @attrib = { 
    color:     Attrib.create!(name: 'Color',     display_number: 3),
    thickness: Attrib.create!(name: 'Thickness', display_number: 1),
    size:      Attrib.create!(name: 'Size',      display_number: 2),
    model:     Attrib.create!(name: 'Model',     display_number: 4)
  }

  @basic_item = Item.new(item_base_name: "Test Product", supplier: @supplier, unit: "piece")



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

