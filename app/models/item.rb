class Item < ActiveRecord::Base
  attr_accessor :item_base_name

  validates :item_base_name, presence: true, unless: :item_base
  validates :name, presence: true
  validates :item_base, presence: true
  validates :supplier, presence: true
  validates :unit, presence: true
  validates_with ItemNameValidator, on: :create

  belongs_to :item_base
  belongs_to :supplier

  has_many :attrib_values, 
    class_name: 'AttribItemValue', 
    :dependent => :destroy

  before_validation :populate_item_base, :populate_name
  before_save :populate_item_base_attribs

  # def convert_supplier_name
  #   puts "SSSSSSSSSSSSSSSSSupplier: #{self.supplier_id}"
  #   unless self.supplier_id =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
  #     self.supplier = Supplier.find_or_create_by(name: self.supplier_id)
  #   end
  # end

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

end