require 'rails_helper'

RSpec.describe AttributeItemBase, :type => :model do
  describe "Create" do
    before(:each) do
      ItemBase.destroy_all
      Attribute.destroy_all
      AttributeItemBase.destroy_all
    end

    it "can establish correct relationships" do
      item = ItemBase.create(name: 'ItemBase')
      attribute = Attribute.create(name: 'Size')
      item.Attributes << attribute
      item.save!

      item = item.reload
      expect(item.Attributes.first.name).to eq(attribute.name)
    end
  end
end
