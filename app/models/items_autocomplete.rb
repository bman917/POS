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
        label: "#{item.summary}",
        value: "#{item.summary}",
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
      search_val = search_val.squish
      query = "name LIKE '%#{search_val}%'"
      count = Item.includes(:item_prices).where(query).count
      puts "Phrase search query #{query}, count: #{count}"
      if count == 0
        terms = search_val.squish.split(' ')
        query = ""
        terms.each do |term|
          query = "#{query} (name LIKE '%#{term}%' or unit LIKE '%#{term}%') AND"
        end
        query = query[0..-4].chop #Remove the trailing ' AND'
        puts "Search Query: #{query}"
        count = Item.includes(:item_prices).where(query).count
      end
      puts "Search Result: #{count}"
      if count > 50
        @items = [Item.new(name: "Results: #{count}. Too many to display. Be more specific....")]
      else
        @items = Item.includes(:item_prices).where(query)
      end
    else
      @items = Item.includes(:item_prices).all
    end
  end

  def columns
    @columns = [:name, :unit]
  end

end