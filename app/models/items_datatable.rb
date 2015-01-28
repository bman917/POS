class ItemsDatatable
  delegate :present, :params, :h, :link_to, :number_to_currency, to: :@view


  def initialize(view)
    @view = view
  end

  def as_json(options={})
    {
      draw: params[:draw],
      recordsTotal: Item.all.count,
      recordsFiltered: items.count,
      data: data
    }
  end

  private

  def data
    filtered_items.map do | item |
      {
        DT_RowId: item.id,
        DT_RowClass: "xxxx",
        name: item.name,
        unit: item.unit
      }
      
    end
  end

  def filtered_items
    @filtered_items ||= items.limit(params[:length]).offset(params[:start])
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    search_val = params[:search][:value]
    puts "Search Value: #{search_val}"

    if search_val && !search_val.empty?
      @items = Item.where("name LIKE ? or unit LIKE ?", "%#{search_val}%", "%#{search_val}%")
    else
      @items = Item.all
    end
  end

  def columns
    @columns = [:name, :unit]
  end

end