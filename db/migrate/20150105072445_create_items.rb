class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :item_base, index: true
      t.references :supplier, index: true
      t.text :description
      t.string :unit

      t.timestamps
    end
  end
end
