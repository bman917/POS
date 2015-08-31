class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :start_date
      t.string :end_date
      t.integer :number_of_sales
      t.timestamps
    end
    add_index :reports, :start_date
  end
end
