class ItemsDatatable

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

  def self.columDefs
      
      return_val = '['
      ItemsDatatable.colum_names.each do | column |
        if column == "check_box"
          return_val += "{\"orderable\": false},"
        else
          return_val += "null,"
        end
      end

      return_val.chop + ']'
  end

  def self.columns
      return_val = '['
      ItemsDatatable.colum_names.each do | column |
        return_val += "{\"data\": \"#{column}\"},"
      end

      return_val.chop + ']'
  end

  def self.colum_names
    %w(check_box name unit supplier copy edit)
  end

  def data
    items.map do | item |
      { 
        DT_RowId: item.id, 
        # DT_RowClass: "xxxx", 
        check_box: check_box_tag("item_ids[]", item.id),
        copy: link_to("Copy", copy_item_path(item)),
        name: item.name,
        unit: item.unit,
        supplier: item.supplier.name,
        edit: link_to(edit_img, edit_item_path(item))
      }

      

    end
  end

  def items
    @items ||= fetch_items
  end

  def fetch_items
    search_val = params[:search][:value] if params[:search]
    puts "Search Value: #{search_val}"

    if search_val && !search_val.empty?
      @items_unordered = Item.where("name LIKE ? or unit LIKE ?", "%#{search_val}%", "%#{search_val}%").includes(:supplier)
    else
      @items_unordered = Item.all.includes(:supplier)
    end

    @items_unordered = @items_unordered.limit(params[:length]).offset(params[:start]) if params[:length].to_i >= 0

    ordered_items = @items_unordered

    params[:order].each do | order |
      index = order[1][:column].to_i || 0
      dir = order[1][:dir].to_sym || :desc
      column = ItemsDatatable.colum_names[index]
      puts "Order Column Index: #{index}, Column: #{column}, Dir: #{dir}"
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