require 'rails_helper'

describe Item do 
  before(:each) do
    ItemBase.destroy_all
    Item.destroy_all
    Supplier.destroy_all
    Attrib.destroy_all

    @unit = Unit.find_or_create_by(name: 'Piece', abbrev: 'pcs')
    @attrib = { 
      color:     Attrib.create!(name: 'Color',     display_number: 3),
      thickness: Attrib.create!(name: 'Thickness', display_number: 1),
      size:      Attrib.create!(name: 'Size',      display_number: 2),
      model:     Attrib.create!(name: 'Model',     display_number: 4)
    }

    sign_in
    visit items_path
  end

  describe "Create", js: true do

    it "works!" do
      click_on 'New Item'
      expect(page).to have_css('form#new_item')
      within("table#item_display td#base_item_column") do
        click_on 'Add'
      end
      expect(page).to have_css('form#new_item_base')

      within("form#new_item_base") do
        fill_in 'Name', with: 'EVA'
        click_on 'Save'
      end

      expect(page).to have_no_css('form#new_item_base')

      within 'form#new_item' do
        select('EVA', :from => 'item_item_base_id')
        fill_in 'Description', with: "Lorem ispum"
        within 'td#supplier_column' do
          click_on 'Add'
        end
      end
     
      fill_up_and_submit_new_supplier_form

      within 'form#new_item' do
        select 'TestSupplier', :from => 'item_supplier_id'
        select @unit.name, :from => 'item_unit'
      end

      click_on 'Add Attribute'

      expect(page).to have_css('form#list_attrib')

      within 'form#list_attrib' do
        check "attrib_#{@attrib[:color].id}"
        check "attrib_#{@attrib[:thickness].id}"
        check "attrib_#{@attrib[:model].id}"
        click_on 'Select'
      end

      within 'form#new_item' do
        expect(page).to have_content('Color')
        expect(page).to have_content('Thickness')
        expect(page).to have_content('Model')

        fill_in "attrib_#{@attrib[:color].id}"    , with: 'Black'
        fill_in "attrib_#{@attrib[:thickness].id}", with: '7mm'
        fill_in "attrib_#{@attrib[:model].id}"    , with: 'Linso'
        click_on 'Save'
      end

      expect(page).to have_content("Eva 7mm Black Linso")
      expect(page).to have_content("TestSupplier")
    end
  end
end