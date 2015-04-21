class PurchaseOrder < ActiveRecord::Base
  belongs_to :supplier
  has_many :item_purchase_orders, dependent: :destroy
  has_many :items, through: :item_purchase_orders
  after_save :update_item

  def update_item
    if status_changed?(from: 'CONFIRMED', to: 'PENDING')
      item_purchase_orders.each { | ipo | ipo.decrement_item}
    end
  end

  def po_id
    if id
      sprintf('%07d', id)
    else
      "New un-saved Purchase Order"
    end
  end

  def details
    "PO##{po_id} #{po_date_short_format} #{supplier.try :name}"
  end

  def po_date_short_format
    date.to_time.to_s(:med) if date
  end
end
