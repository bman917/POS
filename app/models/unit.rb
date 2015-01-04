class Unit < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :abbrev, presence: true, uniqueness: true
end
