class Item < ActiveRecord::Base
  attr_accessor :item_base_name

  validates :item_base_name, presence: true, unless: :item_base
  validates :name, presence: true
  validates :item_base, presence: true
  validates :supplier, presence: true
  validates :unit, presence: true
  validates_with ItemNameValidator, on: [:create, :update]

  belongs_to :item_base
  belongs_to :supplier

  has_many :attrib_values, 
    class_name: 'AttribItemValue', 
    :dependent => :destroy

  has_many :item_prices, :dependent => :destroy

  has_many :attribs, through: :attrib_values

  before_validation :populate_item_base, :populate_name
  before_save :populate_item_base_attribs

  default_scope -> { order(:name, :supplier_id) }
  scope :active, -> { order(:name, :supplier_id) }

  def populate_name
    if self.attrib_values.try(:size) > 0
      sorted = attrib_values.sort { |x,y| x.attrib.display_number <=> y.attrib.display_number }
      values = sorted.map { |x| x.value }
      self.name = "#{item_base.name} #{values.join(" ")}".squeeze(" ").capitalize.titleize
    else
      self.name = "#{item_base.name}"
    end
    self #return self so we can chain this method
  end

  def populate_item_base
    if self.item_base == nil && self.item_base_name
      self.item_base = ItemBase.find_or_create_by(name: item_base_name)
    end
  end

  def populate_item_base_attribs
      #puts "item_base_name: #{self.item_base_name}, attrib_values: #{self.attrib_values.size}"
      if self.attrib_values.try(:size) > 0
        #Filter out existing attribs
        new_attribs = attrib_values.select{|av| self.item_base.attribs.exists?(av.attrib) == false}
        self.item_base.attribs << new_attribs.map{ |av| av.attrib }
      end  
  end

  def item_base_name=(name)  
    @item_base_name = name
    self.item_base = ItemBase.find_or_create_by(name: item_base_name)  
  end

  def add_attrib(attrib, value)
    self.attrib_values << AttribItemValue.new(attrib: attrib, value: value)
  end

  def copy_attribs(other_item)
    other_item.attrib_values.each do | av |
      self.add_attrib av.attrib, av.value
    end
  end

  def summary
    "#{name} (#{unit})"
  end

  def price_summary
    "#{item_prices.find_or_create_by(name: 'REGULAR').price} #{item_prices.find_or_create_by(name: 'WHOLESALE').price}"
  end

end