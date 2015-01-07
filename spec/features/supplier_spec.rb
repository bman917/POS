require 'rails_helper'

describe Supplier do 
  before(:each) do
    Supplier.destroy_all
    @existing = Supplier.create(name: "Existing One")
    sign_in
    visit suppliers_path
  end


  describe "Create", js: true do
    before(:each) do
      click_on 'Add Supplier'
      expect(page).to have_css('form#new_supplier')
      expect(page).to have_css('a.close-reveal-modal')
    end

    describe "Form", :form do
      it_should_behave_like "a modal form" 
    end

    it "saves" do
      fill_in 'Name', with: 'TestSupplier'
      click_on 'Save'
      within "table#supplier" do
        expect(page).to have_content('TestSupplier')

        new_supplier = Supplier.find_by_name("TestSupplier")
        expect(new_supplier).to be_truthy
        expect(page).to have_css("tr#supplier#{new_supplier.id}.highlight")
        expect(page).to have_no_css("tr#supplier#{@existing.id}.highlight")
      end
    end

    describe "duplicate" do
      it "error with name" do
        fill_in 'Name', with: "Existing One"
        click_on 'Save'
        expect(page).to have_content("Name has already been taken")
      end
    end
  end
end

def fill_up_and_submit_new_supplier_form
  
end