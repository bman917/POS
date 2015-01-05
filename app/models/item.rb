class Item < ActiveRecord::Base
  attr_accessor :item_base_name

  validates :item_base_name, presence: true
  validates :item_base, presence: true
  validates :supplier, presence: true
  validates :unit, presence: true

  belongs_to :item_base
  belongs_to :supplier

  has_many :attrib_values, 
    class_name: 'AttribItemValue', 
    :dependent => :destroy

  before_validation :populate_item_base
  before_save :populate_item_base_attribs, :populate_description

  def populate_description
     if self.attrib_values.try(:size) > 0
        values = attrib_values.map { | av | av.value}
        self.description = "#{item_base.name} #{values.join(" ")}"
     end
  end
  def populate_item_base
    if self.item_base == nil && self.item_base_name
      self.item_base = ItemBase.find_or_create_by(name: item_base_name)
    end
  end

  def populate_item_base_attribs
      puts "item_base_name: #{self.item_base_name}, attrib_values: #{self.attrib_values.size}"
      if self.attrib_values.try(:size) > 0
        puts "Populating ItemBase attributes..."
        attrib_ids = attrib_values.map { | av | av.attrib_id }
        self.item_base.attribs << Attrib.where(id: attrib_ids)
        self.item_base.save!
      end  
  end

  def item_base_name=(name)  
     @item_base_name = name
     self.item_base = ItemBase.find_or_create_by(name: item_base_name)  
  end
end