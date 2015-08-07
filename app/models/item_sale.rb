class ItemSale < ActiveRecord::Base
  belongs_to :item
  belongs_to :sale

  before_save :calculate_total
  before_save :store_item_price
  after_save :update_sale_total

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

  def update_sale_total
    sale.total = ItemSale.where(sale_id: sale.id).sum(:total)
    sale.save!
  end
end
