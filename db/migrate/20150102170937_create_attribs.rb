class CreateAttribs < ActiveRecord::Migration
  def change
    create_table :attribs do |t|
      t.string :name

      t.timestamps
    end
    add_index :attribs, :name, unique: true
  end
end
