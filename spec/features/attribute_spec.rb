require 'rails_helper'

describe Category do 
  before(:each) do
    Attrib.destroy_all
    @existing = Attrib.create(name: "Existing One")
    sign_in
    visit attribs_path
  end
  
  describe "Create", js: true do
    before(:each) do
      click_on 'Add Attribute'
      expect(page).to have_css('form#new_attrib')
    end

    describe "Form", :form do
      it_should_behave_like "a modal form" 
    end

    it "Creates an Attrib" do
      fill_in 'Name', with: 'Special Attrib'
      click_on 'Save'
      within "table#attrib" do
        expect(page).to have_content('Special Attrib')
        new_attrib = Attrib.find_by_name('Special Attrib')
        expect(new_attrib).to be_truthy
        expect(page).to have_css("tr#attrib#{new_attrib.id}.highlight")
        expect(page).to have_no_css("tr#attrib#{@existing.id}.highlight")
      end
    end

    it "Shows an error when the Attrib already exists" do
      fill_in 'Name', with: "Existing One"
      click_on 'Save'
      expect(page).to have_content("Name has already been taken")
    end

  end
end