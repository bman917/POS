require 'rails_helper'

describe Attrib do 
  before(:each) do
    clear_all
    @supplier = seed_supplier
    @existing_2 = Attrib.create!(name: "Existing Two", display_number: 2)
    @existing_3 = Attrib.create!(name: "Existing Three", display_number: 3)
    @existing_1 = Attrib.create!(name: "Existing One", display_number: 1)

    sign_in
    visit attribs_path
    expect(page).to have_css("table#attrib tbody tr")
  end

  describe "Index", :index do
    it "Orders By Display Number" do
      visit attribs_path
      within("table#attrib tbody tr:first") do
        expect(page).to have_content("Existing One")
      end
    end
  end

  describe "Delete", js: true, delete: true do
    it "Works!" do
      within("table#attrib tbody tr#attrib#{@existing_1.id}") do
        click_on "Delete"
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_no_content(@existing_1.name)
    end

    it "Errors when attrib is linked to an item" do
      @basic_item = Item.new(item_base_name: "Seeded Item Base", supplier: @supplier, unit: "piece")
      @basic_item.add_attrib(@existing_1, "Red")
      @basic_item.save!
      within("table#attrib tbody tr#attrib#{@existing_1.id}") do
        click_on "Delete"
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).to have_content(@existing_1.name)
      expect(page).to have_content("Unable to delete #{@existing_1.name}")
    end
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
      fill_in 'Display number', with: '20'
      click_on 'Save'
      within "table#attrib" do
        expect(page).to have_content('Special Attrib')
        new_attrib = Attrib.find_by_name('Special Attrib')
        expect(new_attrib).to be_truthy
        expect(page).to have_css("tr#attrib#{new_attrib.id}.highlight")
        expect(page).to have_no_css("tr#attrib#{@existing_1.id}.highlight")
        expect(page).to have_no_css("tr#attrib#{@existing_2.id}.highlight")
      end
    end

    it "Shows an error when the Attrib already exists" do
      fill_in 'Name', with: "Existing One"
      fill_in 'Display number', with: "30"
      click_on 'Save'
      expect(page).to have_content("Name has already been taken")
    end
    it "Shows an error on duplication of Display number" do
      fill_in 'Name', with: "Test Attrib For Display Number Test"
      fill_in 'Display number', with: "1"
      click_on 'Save'
      expect(page).to have_content("Display number has already been taken")
    end

  end
end