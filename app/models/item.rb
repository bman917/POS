class Item < ActiveRecord::Base
  attr_accessor :item_base_name, :Attributes, :Attribute_values

  validates :item_base_name, presence: true
  validates :item_base, presence: true
  validates :supplier, presence: true
  validates :unit, presence: true

  belongs_to :item_base
  belongs_to :supplier
end
