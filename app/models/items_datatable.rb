class ItemsDatatable


  def initialize(view, colum_names, options = {})
    @view = view
    @colum_names = colum_names
    @options = options
    @items = options[:items]
    @item_base_id = options[:item_base_id]
    puts "Initialized with #{@items}"
  end

  def as_json(options={})
    {
      draw: params[:draw],
      data: data,
      recordsTotal: Item.all.count,
      recordsFiltered: @recordsFiltered
    }
  end

  def columDefs
      
      return_val = '['
      @colum_names.each do | column |
        if column == "check_box"
          return_val += "{\"orderable\": false},"
        else
          return_val += "null,"
        end
      end

      return_val.chop + ']'
  end

  def columns
      length = {input: "4em", name: "30em", unit: "3em", pending_orders: "3em"}

      return_val = '['
      @colum_names.each do | column |
        return_val += "{\"data\": \"#{column}\", \"width\": \"#{length[column.to_sym]}\" },"
      end

      return_val.chop + ']'
  end

  def input_qty(item_id)
    content_tag :div do
      content = number_field_tag("items[][qty]", nil, class: "order_qty")
      content << hidden_field_tag("items[][id]", item_id)
    end.html_safe
  end

  def data
    items.map do | item |
      { 
        DT_RowId: item.id, 
        check_box: check_box_tag("item_ids[]", item.id, nil, class: 'icb'),
        input: input_qty(item.id),
        copy: link_to("Copy", copy_item_path(item), remote: true),
        name: item.name,
        unit: item.unit,
        supplier: (item.supplier.try(:name) || "Deleted!!!"),
        pending_orders: item.pending_orders,
        price_summary: item.price_summary,
        summary: "#{item.name} <span class='unit'>(#{item.unit.humanize})</span>",
        edit: link_to(edit_img, edit_item_path(item)),
      }
    end
  end

  def items
    if @item_base_id
      @items ||= fetch_by_item_base
    else
      @items ||= fetch_items
    end
  end

  def fetch_items
    search_val = params[:search][:value] if params[:search]
    #puts "Search Value: #{search_val}"

    if search_val && !search_val.empty?
      @items_unordered = Item.where("name LIKE ? or unit LIKE ?", "%#{search_val}%", "%#{search_val}%").includes(:supplier, :item_prices)
    else
      @items_unordered = Item.all.includes(:supplier, :item_prices)
    end

    @items_unordered = @items_unordered.where(supplier: @options[:supplier]) if @options[:supplier]

    @recordsFiltered = @items_unordered.count

    @items_unordered = @items_unordered.limit(params[:length]).offset(params[:start]) if params[:length].to_i >= 0

    ordered_items = @items_unordered

    params[:order].each do | order |
      index = order[1][:column].to_i || 0
      dir = order[1][:dir].to_sym || :desc
      column = @colum_names[index]
      #puts "Order Column Index: #{index}, Column: #{column}, Dir: #{dir}"
      if column
        ordered_items = @items_unordered.sort_by { | i | i.send(column) }
        ordered_items = ordered_items.reverse if dir == :desc
      end
    end
    ordered_items
  end

  def fetch_by_item_base
    search_val = params[:search][:value] if params[:search]
    #puts "Search Value: #{search_val}"

    if search_val && !search_val.empty?
      supplier_id = Supplier.where("name LIKE ?", "%#{search_val}%").select("id").map{|s|s.id}
      if supplier_id.count > 0
        @items_unordered = Item.where(supplier_id: supplier_id, item_base_id: @item_base_id).includes(:supplier, :item_prices)
      else
        @items_unordered = Item.where("item_base_id = #{@item_base_id} and (name LIKE ? or unit LIKE ?)", "%#{search_val}%", "%#{search_val}%").includes(:supplier, :item_prices)
      end
    else
      @items_unordered = Item.where("item_base_id = #{@item_base_id}").includes(:supplier, :item_prices)
    end

    @items_unordered = @items_unordered.where(supplier: @options[:supplier]) if @options[:supplier]

    @recordsFiltered = @items_unordered.count

    @items_unordered = @items_unordered.limit(params[:length]).offset(params[:start]) if params[:length].to_i >= 0

    ordered_items = @items_unordered

    params[:order].each do | order |
      index = order[1][:column].to_i || 0
      dir = order[1][:dir].to_sym || :desc
      column = @colum_names[index]
      #puts "Order Column Index: #{index}, Column: #{column}, Dir: #{dir}"
      if column
        ordered_items = @items_unordered.sort_by { | i | i.send(column) }
        ordered_items = ordered_items.reverse if dir == :desc
      end
    end
    ordered_items
  end

  def method_missing(*args, &block)
    @view.send(*args, &block)
  end

end