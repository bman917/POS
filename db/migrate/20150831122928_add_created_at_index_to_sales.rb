class AddCreatedAtIndexToSales < ActiveRecord::Migration
  def change
  	add_index :sales, :created_at
  end
end
