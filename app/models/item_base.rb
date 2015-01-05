class ItemBase < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_and_belongs_to_many :Attributes, join_table: 'attribute_item_bases', association_foreign_key: 'attribute_id'
end
