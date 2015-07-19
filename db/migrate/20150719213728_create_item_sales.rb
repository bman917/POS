class CreateItemSales < ActiveRecord::Migration
  def change
    create_table :item_sales do |t|
      t.references :item, index: true
      t.references :sale, index: true
      t.float :qty
      t.float :price
      t.float :total

      t.timestamps
    end
  end
end
