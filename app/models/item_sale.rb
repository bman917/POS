class ItemSale < ActiveRecord::Base
  belongs_to :item
  belongs_to :sale

  before_save :calculate_total
  before_save :store_item_price

  #if the time has no REGULAR price
  #then update the item with the price for this item_sale
  def store_item_price
  	unless item.regular_price
  		item.regular_price = self.price
  	end
  end

  def calculate_total
  	self.total = price * qty
  end

  def css_id
    "item_sale_#{id}"
  end
end
