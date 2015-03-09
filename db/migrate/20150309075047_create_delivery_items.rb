class CreateDeliveryItems < ActiveRecord::Migration
  def change
    create_table :delivery_items do |t|
      t.references :item, index: true
      t.references :delivery, index: true
      t.references :purchase_order, index: true
      t.integer :quantity
      t.float :unit_price
      t.float :total_price
      t.text :notes

      t.timestamps
    end
  end
end
