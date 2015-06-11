class Supplier < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_many :items, :dependent => :destroy
end
