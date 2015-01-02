class CreateItemBases < ActiveRecord::Migration
  def change
    create_table :item_bases do |t|
      t.string :name

      t.timestamps
    end
    add_index :item_bases, :name
  end
end
