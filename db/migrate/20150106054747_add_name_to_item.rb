class AddNameToItem < ActiveRecord::Migration
  def change
    add_column :items, :name, :string
    add_index :items, [:name, :supplier_id, :unit], unique: true
  end
end
