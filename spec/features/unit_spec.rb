require 'rails_helper'

describe Unit do 
  before(:each) do
    Unit.destroy_all
    @existing = Unit.create(name: "Existing One", abbrev: "ExistingAbbrev")
    sign_in
    visit units_path
  end

  describe "Create", js: true do
    before(:each) do
      click_on 'Add Unit'
      expect(page).to have_css('form#new_unit')
    end

    it "saves" do
      fill_in 'Name', with: 'TestUnit'
      fill_in 'Abbrev', with: 'TestAbbrev'
      click_on 'Save'
      within "table#unit" do

        expect(page).to have_content('TestUnit')
        expect(page).to have_content('TestAbbrev')

        new_unit = Unit.find_by_name("TestUnit")
        expect(new_unit).to be_truthy
        expect(page).to have_css("tr#unit#{new_unit.id}.highlight")
        expect(page).to have_no_css("tr#unit#{@existing.id}.highlight")
      end
    end

    describe "duplicate" do
      it "error with name" do
        fill_in 'Name', with: "Existing One"
        fill_in 'Abbrev', with: "DifferentAbbrev"
        click_on 'Save'
        expect(page).to have_content("Name has already been taken")
      end
      it "error with abbrev" do
        fill_in 'Name', with: "DifferentName"
        fill_in 'Abbrev', with: "ExistingAbbrev"
        click_on 'Save'
        expect(page).to have_content("Abbrev has already been taken")
      end

    end
  end
end