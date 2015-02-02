class ItemPurchaseOrder < ActiveRecord::Base
  belongs_to :item
  belongs_to :purchase_order

  validates :quantity, numericality: true
end
