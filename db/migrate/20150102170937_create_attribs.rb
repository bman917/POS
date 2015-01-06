class CreateAttribs < ActiveRecord::Migration
  def change
    create_table :attribs do |t|
      t.string :name
      t.integer :display_number
      t.timestamps
    end
    add_index :attribs, :name, unique: true
    add_index :attribs, :display_number, unique: true
  end
end
