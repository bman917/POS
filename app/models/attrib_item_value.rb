class AttribItemValue < ActiveRecord::Base
  belongs_to :item
  #belongs_to :Attribute, class_name: 'Attribute', foreign_key: 'attribute_id'
  belongs_to :attrib
end
