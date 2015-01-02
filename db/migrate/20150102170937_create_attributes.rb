class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.string :name

      t.timestamps
    end
    add_index :attributes, :name
  end
end
