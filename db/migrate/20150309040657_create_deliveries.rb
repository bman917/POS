class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.date :date
      t.references :supplier, index: true
      t.string :supplier_dr_number
      t.text :notes

      t.timestamps
    end
  end
end
