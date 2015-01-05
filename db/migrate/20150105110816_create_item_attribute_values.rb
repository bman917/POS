class CreateItemAttributeValues < ActiveRecord::Migration
  def change
    create_table :item_attribute_values do |t|
      t.references :item, index: true
      t.references :attribute, index: true
      t.string :value

      t.timestamps
    end
  end
end
