class ItemBase < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #has_and_belongs_to_many :attribs, join_table: 'attrib_item_bases', association_foreign_key: 'attrib_id'
  has_many :attrib_item_bases, :dependent => :destroy
  has_many :attribs, through: :attrib_item_bases
  has_many :items, :dependent => :destroy


  # supplier_a: {
  #   "Thickness"=>#<Set: {"7mm"}>, 
  #   "Color"=>#<Set: {"Black"}>, 
  #   "Model"=>#<Set: {"Linso"}>, 
  #   :unit=>#<Set: {"sheet"}>, 
  #   :supplier=>#<Set: {"Supplier_a"}>},
  # supplier_b: {
  #   ...
  #   ...
  # }
  def map_by_supplier
    item_by_supplier = items.group_by { |i| i.supplier.name}

    item_by_supplier.each do | supplier_name, items |
      map = {}
      items.each do |i |
        i.attrib_values.each do | av |
          map[av.attrib.name] = Set.new unless map[av.attrib.name]
          map[av.attrib.name] << av.value
        end

      map[:unit] = Set.new unless map[:unit]
      map[:unit] << i.unit
      end

      map[:supplier] = Set.new unless map[:supplier]
      map[:supplier] << supplier_name

      item_by_supplier[supplier_name] = map
    end

    item_by_supplier
  end

  # "Thickness": { "Supplier_a": ["7mm"], "Supplier_b": ["7mm"]},
  # "Color": { "Supplier_a": ["Black"], "Supplier_b": ["White"] },
  # ...
  def map_by_attrib_then_supplier
    map = {}
      items.each do | i |
        if i.supplier
          i.attrib_values.each do | av |
            map[av.attrib.name] = {} unless map[av.attrib.name]
            map[av.attrib.name][i.supplier.name] = Set.new unless map[av.attrib.name][i.supplier.name]
            map[av.attrib.name][i.supplier.name] << av.value
          end

          map[:unit] = {} unless map[:unit]

          map[:unit][i.supplier.name] = Set.new unless map[:unit][i.supplier.name]
          map[:unit][i.supplier.name] << i.unit
        end
      end
      map
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