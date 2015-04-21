class ItemPurchaseOrder < ActiveRecord::Base
  belongs_to :item
  belongs_to :purchase_order
  validates :quantity, numericality: true

  #after_save :update_item
  #after_destroy :decrement_item

  def increment_item
  	item.pending_orders += quantity
  	item.save!
  end

  def decrement_item
  	item.pending_orders -= quantity
  	item.save!
  end
end
