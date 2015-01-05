class CreateAttribItemValues < ActiveRecord::Migration
  def change
    create_table :attrib_item_values do |t|
      t.references :item, index: true
      t.references :attrib, index: true
      t.string :value

      t.timestamps
    end
  end
end
