require 'rails_helper'

RSpec.describe Item, :type => :model do
  before(:each) do
    @supplier = Supplier.create(name: "Supplier_1")
  end

  describe "Create" do
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

    it "Auto creates ItemBase and Attribs" do
      Item.destroy_all
      ItemBase.destroy_all

      attrib1 = Attrib.find_or_create_by(name: 'Color')
      attrib2 = Attrib.find_or_create_by(name: 'Thickness')
      puts Attrib.class.name

      base_attribs = [AttribItemValue.new(attrib_id: attrib1.id, value: "Red")]
      base_attribs << AttribItemValue.new(attrib_id: attrib2.id, value: "1/2")

      item = Item.new(item_base_name: "Test Product", supplier: @supplier, unit: "piece", attrib_values: base_attribs)
      item.save!

      reloaded = item.reload
      expect(reloaded.attrib_values.count).to eq(base_attribs.size)
      expect(reloaded.item_base.name).to eq(item.item_base_name)
      expect(reloaded.item_base.attribs.count).to eq(base_attribs.size)

    end
  end
end