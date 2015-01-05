class CreateAttributeItemBases < ActiveRecord::Migration
  def change
    create_table :attribute_item_bases do |t|
      t.integer :attribute_id
      t.integer :item_base_id

      t.timestamps
    end
  end
end
