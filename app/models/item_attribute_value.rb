class ItemAttributeValue < ActiveRecord::Base
  belongs_to :item
  belongs_to :Attribute, class_name: 'Attribute', foreign_key: 'attribute_id'
end
