class CreateItemPrices < ActiveRecord::Migration
  def change
    create_table :item_prices do |t|
      t.references :item, index: true
      t.float :price
      t.string :name

      t.timestamps
    end
  end
end
