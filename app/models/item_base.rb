class ItemBase < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #has_and_belongs_to_many :attribs, join_table: 'attrib_item_bases', association_foreign_key: 'attrib_id'
  has_many :attrib_item_bases, :dependent => :destroy
  has_many :attribs, through: :attrib_item_bases
end