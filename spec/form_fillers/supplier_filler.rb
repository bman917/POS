def fill_up_and_submit_new_supplier_form
  expect(page).to have_css('form#new_supplier')
  within "form#new_supplier" do
    fill_in 'supplier_name', with: 'TestSupplier'
    click_on 'Save'
  end
end