require 'rails_helper'

describe PurchaseOrder do
  
  before(:each) do
    @purchase_order_show_details_css = "#purchase_order_show_details"
    item_spec_seed
    sign_in
  end

  describe 'Create', :js, :create do
    before(:each) do
      @purchase_order_show_details_css = "#purchase_order_show_details"
      @items = create_items(10)
      visit purchase_orders_path

      expect(page).to have_content "No Purchase Order Selected"
      
      click_on 'New Purchase Order'
      page.driver.browser.switch_to.alert.accept
      
      expect(page).to have_css @purchase_order_show_details_css
    end

    describe 'Add Item' do
      before(:each) do
        within @purchase_order_show_details_css do
          click_on 'Add Item'
        end
      end

      it "Initially has no Add button" do
        within @purchase_order_show_details_css do
          expect(page).to have_no_selector("tr#add_item a#add_item_button")
        end
      end

      it 'Disables Add button link with invalid item name' do
        fill_autocomplete 'item_name', with: "Seeded Item Base"
        expect(page).to have_selector("tr#add_item a#add_item_button")

        fill_in 'item_name', with: 'XXXX'
        page.execute_script %Q{ $('#item_purchase_order_quantity').trigger('focus') }
        expect(page).to have_no_selector("tr#add_item a#add_item_button")
      end

      it "rejects invalid quantity", :reject do
        fill_autocomplete 'item_name', with: "Seeded Item Base"
        expect(page).to have_selector("tr#add_item a#add_item_button")
        within 'tr#add_item' do
          fill_in 'item_purchase_order_quantity', with: "XX"
          click_on 'Add'
        end
        expect(page).to have_content("Save failed")
        expect(page).to have_content("Quantity is not a number")
        
      end

      describe 'Create', :add_item_create do
        before(:each) do
          fill_autocomplete 'item_name', with: "Seeded Item Base"
          sleep 0.5
          has_focus = page.evaluate_script("document.activeElement.id") == "item_purchase_order_quantity"
          expect(has_focus ).to be_truthy

          fill_in 'item_purchase_order_quantity', with: "10"
        end
        it 'works with return key' do
          find('#item_purchase_order_quantity').native.send_keys(:return)
        end

        it 'works with Add button link' do
          within 'tr#add_item' do
            click_on 'Add'
          end
        end


        after(:each) do
          within @purchase_order_show_details_css do
            expect(page).to have_css('tr.highlight')
            expect(page).to have_content('Seeded Item Base')
            expect(page).to have_no_css('#item_name')
          end
        end
      end
    end
  end

  describe 'Destroy', :js, :destroy do
    before(:each) do
      @purchase_orders = create_purchase_orders(30)
      visit purchase_orders_path
    end

    it 'works!' do
      first_po = @purchase_orders.first
      first_record = "#po_list #purchase_orders tbody td:first"
      first_record = "#purchaseorder#{first_po.id}"
      
      #Click on first record to display it
      page.evaluate_script("$('#{first_record} td').click();")
      expect(page).to have_content("PO# 000")

      id = page.evaluate_script("$('#{first_record}').attr('id');")
      expect(page).to have_selector("#po_list #purchase_orders tbody tr##{id}")
      within first_record do
        click_on 'Delete'
      end

      #Modal for confirmtin deletion
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content "No Purchase Order Selected"
      expect(page).to have_no_css first_record

      #When the PO is deleted it should go to the deleted list
      select("DELETED", from: 'po_status')
      expect(page).to have_css first_record

      page.evaluate_script("$('#{first_record} td').click();")
      expect(page).to have_content("PO# 000")
      within first_record do
        click_on 'Delete'
      end
      expect(page).to have_content("Permanently Delete PO# #{first_po.po_id}")

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

      @first_record = "#po_list #purchase_orders tbody tr:first td:first"
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
        expect(page).to have_content "Successfully Deleted 1 item"
      end
    end

    describe "Menu", :show_menu, :js do
      describe "Status Control Options" do
        it 'has set to confirmed works' do

          initial_row_count = all('table#purchase_orders tr').count

          find('#actions_menu').click
          click_on('Confirm This PO')
          page.driver.browser.switch_to.alert.accept
          within '#show_details_notifications' do
            expect(page).to have_content ('PO Status Updated')
          end
          
          #Check that the PO status label has been updated
          expect(find('#purchase_order_status').text).to eq('CONFIRMED')

          expect(page).to have_css('table#purchase_orders tr', :count == (initial_row_count - 1))
        end
      end
    end
  end
end