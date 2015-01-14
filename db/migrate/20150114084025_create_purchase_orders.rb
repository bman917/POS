class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.references :supplier, index: true
      t.string :status
      t.text :notes
      t.date :date

      t.timestamps
    end
  end
end
