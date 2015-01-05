class CreateAttribItemBases < ActiveRecord::Migration
  def change
    create_table :attrib_item_bases, id: false do |t|
      t.references :attrib, index: true
      t.references :item_base, index: true

      t.timestamps
    end
  end
end
