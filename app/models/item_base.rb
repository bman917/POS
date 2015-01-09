class ItemBase < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #has_and_belongs_to_many :attribs, join_table: 'attrib_item_bases', association_foreign_key: 'attrib_id'
  has_many :attrib_item_bases, :dependent => :destroy
  has_many :attribs, through: :attrib_item_bases
  has_many :items

  def map_by_supplier
    items.group_by { |i| i.supplier.name}
  end

  def map
    map = {}
    items.each do | i |
      i.attrib_values.each do | av |
        map[av.attrib.name] = Set.new unless map[av.attrib.name]
        map[av.attrib.name] << av.value
      end

      map[:supplier] = Set.new unless map[:supplier]
      map[:supplier] << i.supplier.name

      map[:unit] = Set.new unless map[:unit]
      map[:unit] << i.unit
    end
    map
  end
end