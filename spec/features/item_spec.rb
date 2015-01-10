require 'rails_helper'

def item_spec_seed
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
end

describe Item do 
  before(:each) do
    @add_attribute_button =  'Add Attribute'
    sign_in
    visit items_path
  end

  describe "Create", :js, :create do
    before(:each) do
      item_spec_seed

      @supplier1 = Supplier.create(name: "Supplier_1")
      @basic_item = Item.new(item_base_name: "Seeded Item Base", supplier: @supplier1, unit: "piece")
      @basic_item.add_attrib(@attrib[:color], "Red")
      @basic_item.add_attrib(@attrib[:size], "Small")
      @basic_item.add_attrib(@attrib[:thickness], "1/2")
      @basic_item.save!

      click_on 'New Item'
      expect(page).to have_css('form#new_item')
    end

    describe "Item Form", :item_form do
      it "focus by default on Item Base" do
        expect_html_focus_on "item_item_base_id"
      end

      it "auto-adds attribs when ItemBase is selected" do
        expect(page).to have_no_content(@attrib[:color].name)
        expect(page).to have_no_content(@attrib[:size].name)
        expect(page).to have_no_content(@attrib[:thickness].name)

        within 'form#new_item' do
          select('Seeded Item Base', :from => 'item_item_base_id')
          expect(page).to have_content(@attrib[:color].name)
          expect(page).to have_content(@attrib[:size].name)
          expect(page).to have_content(@attrib[:thickness].name)
        end
      end
    end

    describe "ItemBase Form", :item_base_form do
      before(:each) do
        within("table#item_display td#base_item_column") do
          click_on 'Add'
        end
        expect(page).to have_css('form#new_item_base')
      end

      it "focus by default on Item Base name" do
        within("form#new_item_base") do
          expect_html_focus_on "item_base_name"
        end
      end

      it "after save focuses on Item Base input" do
        within("form#new_item_base") do
          fill_in 'Name', with: 'EVA'
          click_on 'Save'
        end
        expect_html_focus_on "item_item_base_id"
      end
    end

    describe "Supplier Form", :supplier_form do
      before(:each) do
        within 'td#supplier_column' do
          click_on 'Add'
        end
        expect(page).to have_css('form#new_supplier')
      end

      it "focus by default on Supplier name" do
        within("form#new_supplier") do
          expect_html_focus_on "supplier_name"
        end
      end

      it "after save focuses on Suppler input" do
        within "form#new_supplier" do
          fill_in 'supplier_name', with: 'TestSupplier'
          click_on 'Save'
        end
        expect_html_focus_on "item_supplier_id"
      end
    end

    it "works!", :works do

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
     
      expect(page).to have_css('form#new_supplier')
      within "form#new_supplier" do
        fill_in 'supplier_name', with: 'TestSupplier'
        click_on 'Save'
      end

      expect(page).to have_no_css('form#new_supplier')

      within 'form#new_item' do
        select 'TestSupplier', :from => 'item_supplier_id'
        select @unit.name, :from => 'item_unit'
      end

      select_attribs do
        check "attrib_#{@attrib[:model].id}"
        check "attrib_#{@attrib[:color].id}"
        check "attrib_#{@attrib[:thickness].id}"
      end

      within 'form#new_item' do
        expect(page).to have_content('Color')
        expect(page).to have_content('Thickness')
        expect(page).to have_content('Model')
        expect_html_focus_on "attrib_#{@attrib[:thickness].id}"
        
        fill_in "attrib_#{@attrib[:thickness].id}", with: '7mm'
        fill_in "attrib_#{@attrib[:model].id}"    , with: 'Linso'
        fill_in "attrib_#{@attrib[:color].id}"    , with: 'Black'
        click_on 'Save'
      end

      expect(page).to have_content("Eva 7mm Black Linso")
      expect(page).to have_content("TestSupplier")
    end
  end

  describe "Edit", :js, :edit do
    before(:each) do
      item_spec_seed
      @supplier1 = Supplier.create(name: "Supplier_1")
      @supplier2 = Supplier.create(name: "Supplier_2")

      @basic_item = Item.new(item_base_name: "Test Product", supplier: @supplier1, unit: "piece")
      @basic_item.add_attrib(@attrib[:color], "Red")
      @basic_item.add_attrib(@attrib[:size], "Small")
      @basic_item.add_attrib(@attrib[:thickness], "1/2")
      @basic_item.save!

      @edit_from_id = "form#edit_item_#{@basic_item.id}"
      @basic_item_row_id = "tr#item#{@basic_item.id}"
      @item_display_id = "table#item_display"

      visit items_path
      within @basic_item_row_id do
        click_on 'Edit'
      end

      expect(page).to have_css(@edit_from_id)
    end

    it "supplier works!" do
      within @edit_from_id do
        select @supplier2.name, :from => 'item_supplier_id'
        click_on 'Save'
      end
      within @item_display_id do
        expect(page).to have_content(@supplier2.name)
      end
    end

    it "existing attrib works!" do
      within @edit_from_id do
        fill_in "attrib_#{@attrib[:thickness].id}"    , with: '1/4'
        click_on 'Save'
      end
      within @item_display_id do
        expect(page).to have_no_content("1/2")
        expect(page).to have_content("1/4")
      end
    end

    it "add attrib works!" do
      select_attribs do
        check "attrib_#{@attrib[:model].id}"
      end

      within @edit_from_id do
        expect(page).to have_content('Model')
        fill_in "attrib_#{@attrib[:model].id}"    , with: 'Linso'
        click_on 'Save'
      end

      within @item_display_id do
        expect(page).to have_content('Linso')
      end
    end

  end
end

def select_attribs
  click_on @add_attribute_button
  expect(page).to have_css('form#list_attrib')
  puts "Expecting focus on attrib: #{@attrib[:thickness].id}, #{@attrib[:thickness].name}"
  within 'form#list_attrib' do
    expect_html_focus_on "attrib_#{@attrib[:thickness].id}"
    yield
    click_on 'Select'
  end
  expect(page).to have_no_css('form#list_attrib')
end