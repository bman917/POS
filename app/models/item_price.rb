class ItemPrice < ActiveRecord::Base
  belongs_to :item
  validates :price, presence: true
  validates :price, numericality: {greater_than: 0}
  validates :name, uniqueness: { scope: :item_id,
    message: "Only 1 price type per item." }
end
