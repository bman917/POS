class AddPaymentToSales < ActiveRecord::Migration
  def change
    add_column :sales, :payment_1, :float
    add_column :sales, :payment_2, :float
    add_column :sales, :payment_3, :float
    add_column :sales, :payment_4, :float
  end
end
