module Seeder

  def clear_all
    ItemBase.destroy_all
    Item.destroy_all
    Supplier.destroy_all
    Attrib.destroy_all
    PurchaseOrder.destroy_all
  end

  def basic_seed
    @unit = Unit.find_or_create_by(name: 'Piece', abbrev: 'pcs')
    @attrib = { 
      color:     Attrib.create!(name: 'Color',     display_number: 3),
      thickness: Attrib.create!(name: 'Thickness', display_number: 1),
      size:      Attrib.create!(name: 'Size',      display_number: 2),
      model:     Attrib.create!(name: 'Model',     display_number: 4)
    }

  end

  def item_spec_seed
    clear_all
    basic_seed
  end

  def item_spec_create_basic_item
    @basic_item = Item.new(item_base_name: "Seeded Item Base", supplier: @supplier1, unit: "piece")
    @basic_item.add_attrib(@attrib[:color], "Red")
    @basic_item.add_attrib(@attrib[:size], "Small")
    @basic_item.add_attrib(@attrib[:thickness], "1/2")
    @basic_item.save!
  end

  def create_items(number)
    @items = []
    @supplier1 = Supplier.find_or_create_by(name: "Supplier_1")

    number.times do | i |
      item = Item.new(item_base_name: "Seeded Item Base", supplier: @supplier1, unit: "piece")      
      item.add_attrib(@attrib[:color], "Red")
      item.add_attrib(@attrib[:size], "Small")
      item.add_attrib(@attrib[:model], i.to_s)
      item.save!
      @items << item
    end
    return @items
  end

  def create_purchase_orders(number)
    PurchaseOrder.destroy_all
    expect(ItemPurchaseOrder.all.count).to eq 0
    
    @supplier1 = Supplier.find_or_create_by(name: "Supplier_1")
    number.times do | i |
      PurchaseOrder.create!(supplier: @supplier1, status: 'PENDING', date: Date.today)      
    end
    PurchaseOrder.all
  end
end