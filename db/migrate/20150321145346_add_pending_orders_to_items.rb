class AddPendingOrdersToItems < ActiveRecord::Migration
  def change
  	add_column :items, :pending_orders, :integer, :defaut => 0

  	Item.update_all( pending_orders: 0)

  end
end
