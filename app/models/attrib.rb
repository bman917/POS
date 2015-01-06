class Attrib < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :display_number, presence: true, uniqueness: true
  belongs_to :attrib_item_value
end
