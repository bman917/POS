require 'rails_helper'

describe Category do 
  before(:each) do
    Attribute.destroy_all
    @existing = Attribute.create(name: "Existing One")
    sign_in
    visit attributes_path
  end
  
  describe "Create", js: true do
    before(:each) do
      click_on 'New Attribute'
      expect(page).to have_css('form#new_attribute')
    end

    it "Creates an Attribute" do
      fill_in 'Name', with: 'Special Attribute'
      click_on 'Save'
      within "table#attribute" do
        expect(page).to have_content('Special Attribute')
        new_attribute = Attribute.find_by_name('Special Attribute')
        expect(new_attribute).to be_truthy
        expect(page).to have_css("tr#attribute_#{new_attribute.id}.highlight")
        expect(page).to have_no_css("tr#attribute_#{@existing.id}.highlight")
      end
    end

    it "Shows an error when the Attribute already exists" do
      fill_in 'Name', with: "Existing One"
      click_on 'Save'
      expect(page).to have_content("Name has already been taken")
    end

  end
end