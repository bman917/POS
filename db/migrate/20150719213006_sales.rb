class Sales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.string :created_by
      t.string :prepared_by
      t.string :checked_by
      t.float :total
      t.float :vat
      t.float :grand_total
      t.timestamps
    end
  end
end
