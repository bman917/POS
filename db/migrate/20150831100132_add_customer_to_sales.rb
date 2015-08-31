class AddCustomerToSales < ActiveRecord::Migration
  def change
    add_column :sales, :customer_name, :string
  end
end
