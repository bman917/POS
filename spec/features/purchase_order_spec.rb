require 'rails_helper'

describe PurchaseOrder do
  
  before(:each) do

    @purchase_order_show_details_css = "#purchase_order_show_details"
    @items = create_items(10)
    sign_in
    visit purchase_orders_path
  end

  describe 'Create', :js do
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

end