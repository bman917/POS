require 'rails_helper'

describe Category do 
  before(:each) do
    Category.destroy_all
    @existing_category = Category.create(name: "Existing One")
    sign_in
  end
  
  describe "Create", js: true do
    before(:each) do
      click_on 'Manage Items'
      click_on 'Add Category'
      expect(page).to have_css('form#new_category')
    end

    it "Creates a Category" do
      fill_in 'Name', with: 'EVA Sheet'
      click_on 'Save'
      within "table#category" do
        expect(page).to have_content('EVA Sheet')
        new_category = Category.find_by_name('EVA Sheet')
        expect(new_category).to be_truthy
        expect(page).to have_css("tr#category_#{new_category.id}.highlight")
        expect(page).to have_no_css("tr#category_#{@existing_category.id}.highlight")
      end
    end

    it "Shows an error when the Cateogry already exists" do
      fill_in 'Name', with: "Existing One"
      click_on 'Save'
      expect(page).to have_content("'Existing One' category already exists.")
    end

  end
end