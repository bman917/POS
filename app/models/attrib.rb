class Attrib < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :display_number, presence: true, uniqueness: true
  has_many :attrib_item_value
  has_many :items, through: :attrib_item_value, :dependent => :restrict_with_error
  scope :active, -> { order(display_number: :asc) }

  after_save :update_item_names, if: :display_number_updated

  def display_number_updated
    self.changes[:display_number].try(:size) > 0 && items.try(:count) > 0
  end


  #
  #When the display_number is updated, 
  #the Item names also need to be updated
  #
  def update_item_names
    puts "Display number of #{self.name} changed. Updating names of '#{items.count}' Items...."
    items.each { | i | i.populate_name.save }
  end
end
