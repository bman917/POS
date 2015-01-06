class AttribItemValue < ActiveRecord::Base
  validates :value, presence: true
  validates :attrib, presence: true
  validates :item, presence: true


  belongs_to :item
  #belongs_to :Attribute, class_name: 'Attribute', foreign_key: 'attribute_id'
  belongs_to :attrib
end
