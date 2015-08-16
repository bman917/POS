class AddStatusToSales < ActiveRecord::Migration
  def change
  	add_column :sales, :status, :string
  end
end
