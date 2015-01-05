class Attrib < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :attrib_item_value
end
