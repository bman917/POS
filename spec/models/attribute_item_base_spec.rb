require 'rails_helper'

RSpec.describe AttribItemBase, :type => :model do
  describe "Create" do
    before(:each) do
      ItemBase.destroy_all
      Attrib.destroy_all
      AttribItemBase.destroy_all
    end

    it "can establish correct relationships" do
      item = ItemBase.create(name: 'ItemBase')
      attrib = Attrib.create(name: 'Size')
      item.attribs << attrib
      item.save!

      item = item.reload
      expect(item.attribs.first.name).to eq(attrib.name)
    end
  end
end
