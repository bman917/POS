require 'rails_helper'

describe PurchaseOrder do
  
  before(:each) do
    @purchase_order_show_details_css = "#purchase_order_show_details"
    item_spec_seed
    sign_in
  end

  describe 'Create', :js do
    before(:each) do
      @purchase_order_show_details_css = "#purchase_order_show_details"
      @items = create_items(10)
      visit purchase_orders_path
    end

    it 'works!' do
      expect(page).to have_content "No Purchase Order Selected"
      
      click_on 'New Purchase Order'
      page.driver.browser.switch_to.alert.accept
      
      expect(page).to have_css @purchase_order_show_details_css

      within @purchase_order_show_details_css do
        click_on 'Add Item'
      end
      
      fill_autocomplete 'item_name', with: "Seeded Item Base"
      sleep 0.5
      has_focus = page.evaluate_script("document.activeElement.id") == "item_purchase_order_quantity"
      expect(has_focus ).to be_truthy

      fill_in 'item_purchase_order_quantity', with: "10"
      find('#item_purchase_order_quantity').native.send_keys(:return)
      within @purchase_order_show_details_css do
        expect(page).to have_css('tr.highlight')
        expect(page).to have_content('Seeded Item Base')
        expect(page).to have_no_css('#item_name')
      end
    end
  end

  describe 'Destroy', :js, :destroy do
    before(:each) do
      @purchase_orders = create_purchase_orders(30)
      visit purchase_orders_path
    end

    it 'works!' do

      first_record = "#po_list #purchase_orders tbody tr:first"

      #Click on first record to display it
      page.evaluate_script("$('#{first_record}').click();")
      expect(page).to have_content("PO# 000")

      id = page.evaluate_script("$('#{first_record}').attr('id');")
      expect(page).to have_selector("#po_list #purchase_orders tbody tr##{id}")
      within "tr##{id}" do
        click_on 'Delete'
      end

      #Modal for confirmtin deletion
      page.driver.browser.switch_to.alert.accept

      #Model that confirms the delete was successful
      text = page.driver.browser.switch_to.alert.text
      expect(text).to have_content('Deleted')
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content "No Purchase Order Selected"
    end
  end

  describe 'Paging', :js, :paging do
    before(:each) do
      @purchase_orders = create_purchase_orders(50)
      visit purchase_orders_path
    end

    it "works!" do
      expect(page).to have_css(".pagination")
    end
  end

  describe 'Show', :js, :show do
    before(:each) do
      @items = create_items(5)
      @purchase_order_with_items = create_purchase_orders(1).first

      @items.each do | item |
        @purchase_order_with_items.item_purchase_orders.create(item: item, quantity: 10)
      end

      visit purchase_orders_path

      @first_record = "#po_list #purchase_orders tbody tr:first"
      page.evaluate_script("$('#{@first_record}').click();")
    end

    it 'works' do
      expect(page).to have_no_content "No Purchase Order Selected"
      expect(page).to have_content("PO# #{@purchase_order_with_items.po_id}")

      within @purchase_order_show_details_css do
        expect(page).to have_content @items.first.name
      end   
    end

    it 'delete button is disabled initially' do
      within @purchase_order_show_details_css do
        expect(page).to have_button('Delete', disabled: true)
      end
    end

    it 'delete item works' do
      @first_item_purchase_order = @purchase_order_with_items.item_purchase_orders.first
      find(:css, "#item_purchase_order_ids_[value='#{@first_item_purchase_order.id}']").set(true)

      within @purchase_order_show_details_css do
        click_on 'Delete Items'
      end   

      text = page.driver.browser.switch_to.alert.text
      expect(text).to have_content("Delete selected items from PO# #{@purchase_order_with_items.po_id}")
      page.driver.browser.switch_to.alert.accept

      within @purchase_order_show_details_css do
        expect(page).to have_no_content @first_item_purchase_order.item.name
      end

    end
  end
end