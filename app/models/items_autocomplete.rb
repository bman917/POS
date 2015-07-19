class ItemsAutocomplete
  delegate :present, :params, :h, :link_to, :number_to_currency, to: :@view


  def initialize(view)
    @view = view
  end

  def as_json(options={})
    data
  end

  private

  def data
    items.map do | item |
      {
        id: item.id,
        label: "#{item.name} (#{item.unit})",
        value: "#{item.name} (#{item.unit})",
        price: item.regular_price,
        desc: item.unit        
      }
    end
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    search_val = params[:term]
    puts "Search Value: #{search_val}"

    if search_val && !search_val.empty?
      @items = Item.includes(:item_prices).where("name LIKE ? or unit LIKE ?", "%#{search_val}%", "%#{search_val}%")
    else
      @items = Item.includes(:item_prices).all
    end
  end

  def columns
    @columns = [:name, :unit]
  end

end