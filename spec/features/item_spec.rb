require 'rails_helper'

describe Item do 
  before(:each) do
    @add_attribute_button =  'Add Attribute'
    sign_in
    visit items_path
  end

  describe "Index", :js, :index do
    before(:each) do
      item_spec_seed

      @supplier1 = Supplier.create(name: "Supplier_1")

      item_spec_create_basic_item

      @basic_item2 = Item.new(item_base_name: "Seeded Item Base", supplier: @supplier1, unit: "piece")
      @basic_item2.add_attrib(@attrib[:color], "Green")
      @basic_item2.add_attrib(@attrib[:size], "Small")
      @basic_item2.add_attrib(@attrib[:thickness], "1/2")
      @basic_item2.save!
      visit items_path
    end

    describe "Copy" do
      it "works!" do
        within "tr#item#{@basic_item.id}" do
          click_on 'Copy'
        end
        expect(page).to have_css('form#new_item')
        fill_in "attrib_#{@attrib[:color].id}"    , with: 'Black'
        click_on 'Save'
        expect(page).to have_content(@basic_item.name)
        expect(page).to have_content('Seeded Item Base 1/2 Small Red')
      end
    end

    describe "Delete multiple", :delete_multiple do
      it "works" do
        find(:css, "#item_ids_[value='#{@basic_item.id}']").set(true)
        find(:css, "#item_ids_[value='#{@basic_item2.id}']").set(true)
        within "#items_actions" do
          click_on "Delete Checked"
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content("Successfully Deleted 2 Items")
        expect(page).to have_no_content(@basic_item.name)
        expect(page).to have_no_content(@basic_item2.name)
      end
    end
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
      within ".main" do
        click_on 'New Item'
      end
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

    describe "Logic" do
      before(:each) do
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
        end
      end


      it "creates multiple when comma-separated", :create_multiple do
        pending "Not yet done"
        
        within 'form#new_item' do
          fill_in "attrib_#{@attrib[:thickness].id}", with: '1mm, 2mm, 3mm'
          fill_in "attrib_#{@attrib[:model].id}"    , with: 'Linso, Tribu'
          fill_in "attrib_#{@attrib[:color].id}"    , with: 'Black, White, Grey'
          click_on 'Save'
        end

        expect(page).to have_content("Eva 1mm Blk Linso")
        expect(page).to have_content("Eva 2mm Blk Linso")
        expect(page).to have_content("Eva 3mm Blk Linso")
        expect(page).to have_content("Eva 1mm Wht Linso")
        expect(page).to have_content("Eva 2mm Wht Linso")
        expect(page).to have_content("Eva 3mm Wht Linso")
        expect(page).to have_content("Eva 1mm Gry Linso")
        expect(page).to have_content("Eva 2mm Gry Linso")
        expect(page).to have_content("Eva 3mm Gry Linso")
        expect(page).to have_content("TestSupplier")
      end

      it "works!", :works do
        within 'form#new_item' do
          fill_in "attrib_#{@attrib[:thickness].id}", with: '7mm'
          fill_in "attrib_#{@attrib[:model].id}"    , with: 'Linso'
          fill_in "attrib_#{@attrib[:color].id}"    , with: 'Black'
          click_on 'Save'
        end
      end
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