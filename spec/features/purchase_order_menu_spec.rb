require 'rails_helper'

describe 'PurchaseOrder Menu', :js do
  
  before(:each) do
    @purchase_order_show_details_css = "#purchase_order_show_details"
    item_spec_seed

    sign_in

    @items = create_items(5)
    @purchase_orders = create_purchase_orders(2)
    @purchase_order_1 = @purchase_orders.first
    @purchase_order_2 = @purchase_orders.second

    @items.each do | item |
      @purchase_orders.each do |po|
        po.item_purchase_orders.create(item: item, quantity: 10)
      end
    end

    visit purchase_orders_path

    @css_first_record = "#po_list #purchase_orders tbody tr:first td:first"
  end

  it 'confirm two consecutive works' do
    test_confirm(@purchase_order_1)
    test_confirm(@purchase_order_2)
  end

  it 'confirmed works' do

    test_confirm(@purchase_order_1)

    #When the PO is confirmed it should go to the confirmed list
    select("CONFIRMED", from: 'po_status')
    within 'table#purchase_orders' do
      expect(page).to have_content(@purchase_order_1.po_id)
    end

    initial_row_count = all('table#purchase_orders tr').count

    click_po_on_purchase_order_table(@purchase_order_1)

    find('#actions_menu').click
    within ("#purchase_order_show_details") do
      expect(page).to have_no_content("Confirm This PO")
      click_on("Set PO to PENDING")
    end

    expect(page).to have_content ("Set PO# #{@purchase_order_1.po_id} to PENDING?")
    within('.ui-dialog') do
      click_on('Set to Pending')
    end    

    expect(page).to have_content ('Purchase Order Set to Pending')
    
    #Check that the PO status label has been updated
    expect(find('#purchase_order_status').text).to eq('PENDING')

    expect(page).to have_css('table#purchase_orders tr', :count == (initial_row_count - 1))
  end

end

def test_confirm(purchase_order)
   initial_row_count = all('table#purchase_orders tr').count

  click_po_on_purchase_order_table(purchase_order)

  find('#actions_menu').click
  click_on('Confirm This PO')
  
  expect(page).to have_content ("Confirm PO# #{purchase_order.po_id}?")
  within('.ui-dialog') do
    click_on('Confirm')
  end

  expect(page).to have_content ('Purchase Order Confirmed!')
  
  #Check that the PO status label has been updated
  expect(find('#purchase_order_status').text).to eq('CONFIRMED')

  #Row cound should be decremented
  expect(page).to have_css('table#purchase_orders tr', :count == (initial_row_count - 1))

end


#Clikc on a PO in the Purchase Order table
def click_po_on_purchase_order_table(purchase_order)
  po_css_id = "#purchaseorder#{purchase_order.id}"
  page.evaluate_script("$('#{po_css_id} td').click();")
  within ("#purchase_order_show_details") do
    expect(page).to have_content("PO# #{purchase_order.po_id}")
  end
end