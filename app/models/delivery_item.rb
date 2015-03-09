class DeliveryItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :delivery
  belongs_to :purchase_order
end
