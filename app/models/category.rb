class Category < ActiveRecord::Base
  attr_accessor :highlight
  validates :name, presence: true
  #validates :name, uniqueness: {message: }
  validates_with NameValidator, on: :create

  def highlight
    @highlight
  end
end