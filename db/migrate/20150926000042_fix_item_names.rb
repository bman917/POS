class FixItemNames < ActiveRecord::Migration
  def change
  	Item.all.each do |item|
  		item.populate_name.save
  	end
  end
end
