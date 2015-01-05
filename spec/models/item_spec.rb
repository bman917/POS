require 'rails_helper'

RSpec.describe Item, :type => :model do
  describe "Create" do
    it "raises an error when no Supplier and ItemBase" do
      expect { Item.create! }.to raise_error
    end

    it "raises an error when no ItemBase" do
      supplier = Supplier.create(name: "Supplier_1")
      expect { Item.create!(supplier: supplier, item_base: nil) }.to raise_error
    end

    it "raises an error when no Supplier" do
      item_base = ItemBase.create(name: "ItemBase1")
      expect { Item.create!(supplier: nil, item_base: item_base) }.to raise_error
    end
  end
end
