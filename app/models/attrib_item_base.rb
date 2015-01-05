class AttribItemBase < ActiveRecord::Base
  #belongs_to :Attribute, class_name: 'Attribute', foreign_key: 'attribute_id'
  belongs_to :attrib
  belongs_to :item_base
end
