class CreateItemPurchaseOrders < ActiveRecord::Migration
  def change
    create_table :item_purchase_orders do |t|
      t.references :item, index: true
      t.references :purchase_order, index: true
      t.integer :quantity
      t.float :estimated_unit_price
      t.float :estimated_total_price
      t.string :notes

      t.timestamps
    end
  end
end
