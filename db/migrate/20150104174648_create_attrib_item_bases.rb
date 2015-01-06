class CreateAttribItemBases < ActiveRecord::Migration
  def change
    create_table :attrib_item_bases do |t|
      t.references :attrib, index: true
      t.references :item_base, index: true

      t.timestamps
    end
  end
end
