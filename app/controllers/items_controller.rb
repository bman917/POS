class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js


  def autocomplete
  end

  def json
    
    @column_names = %w(check_box name unit supplier pending_orders copy edit)
    @items_datatable = ItemsDatatable.new(view_context, @column_names)
    
    if params[:term]
      #When there is a :term paramter then it means this is an autocomplete json
      render json: ItemsAutocomplete.new(view_context)
    else
      render json: @items_datatable
    end
  end

  def json_filter_by_supplier
    
    @column_names = %w(check_box name unit supplier pending_orders copy edit)
    @items_datatable = ItemsDatatable.new(view_context, @column_names, supplier: selected_supplier)
    
    if params[:term]
      #When there is a :term paramter then it means this is an autocomplete json
      render json: ItemsAutocomplete.new(view_context)
    else
      render json: @items_datatable
    end
  end

  def select
    @items = Item.active
  end

  def destroy_multiple
    begin
      ret_val = Item.destroy_all(id: params[:item_ids])
      flash[:status] = "Successfully Deleted #{ret_val.size} Items"
    rescue Exception => e
      flash[:error] = "Unexpected error while deleting Items: #{e.message}"
    end
    @items = Item.active
    redirect_to action: 'index', flash: flash
  end

  def add_attrib
    @attribs = Attrib.where(id: params[:attrib]).order(:display_number)
  end

  def index
    @items = Item.active
    @column_names = %w(check_box name unit supplier pending_orders copy edit)
    @items_datatable = ItemsDatatable.new(view_context, @column_names)
    respond_with(@items)
  end

  def show
    @cloned_item = Item.new(@item.attributes)
    respond_with(@item)
  end

  def new
    @item = Item.new(item_base: ItemBase.new)
    @attribs = [Attrib.first]

    @item_base = ItemBase.all.first

    respond_with(@item)
  end

  def copy
    orig_item = set_item

    #doing this long-cut, because clone and dup are 
    #not doing what they are supposed to!!!
    new_attributes = orig_item.attributes
    new_attributes.delete("id")

    @item = Item.new(new_attributes)
    @base_attribs = orig_item.attrib_values
    render 'new'

  end

  def edit
    @item = set_item
    @base_attribs = @item.attrib_values
  end

  def handle_new_item_base_add_supplier(params)
    #When a user selects to add a new ItemBase into the 
    #select#item_item_base_id, the option will look like:
    #   <option selected="selected" value="NewValue">NewValue</option>
    #Thus, we should convert item_base_id into item_base_name.
    #The Item model will handle converting the item_base_name
    #into a new ItemBase record.
    unless params[:item_base_id] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      params[:item_base_name] = params[:item_base_id]
      params[:item_base_id] = nil
    end

    #Do the same for Suppliers but this time, handle creation
    unless params[:supplier_id] =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      params[:supplier_id] = Supplier.find_or_create_by(name: params[:supplier_id]).id
    end
    params
  end

  #Collect the Attribs-Values that have been dynamically been added to 
  #the form. 
  #In the case that the Attribs has not yet been associated to the ItemBase. 
  #It will be handled internally within item.rb
  def create_attrib_item_values 
    @base_attribs = []
    @attribs = params[:attrib]
    @attribs.keys.each do | key |
      @base_attribs << AttribItemValue.new(attrib_id: key, value: @attribs[key])
      #puts "AttribItemValue: #{@base_attribs.last.attrib.id}, #{@base_attribs.last.value}"
    end if @attribs
    #puts "Attribs: #{@attribs}, @base_attribs: #{@base_attribs.size}"
    modified_item_parms = item_params
    modified_item_parms[:attrib_values] = @base_attribs
    modified_item_parms
  end

  def do_it(key, comma_delimited_val, orig_attribs)
    ret_val = []
    ary = comma_delimited_val.strip.squeeze(",").squeeze(" ").split(',')
    ary.each do | ary_val |
      cloned_attribs = orig_attribs.clone
      cloned_attribs[key] =  ary_val
      ret_val << cloned_attribs
    end
    ret_val
  end



  def create

    params_attrib = []
    orig_attribs = params[:attrib]
    attribs_clone = orig_attribs.clone
    stage_2 = {}

    #check if there are comma-separated values
    comma = orig_attribs.find_all do |key, value| 
      value.include?(",")
    end

    no_comma = orig_attribs.reject do |key, value| 
      value.include?(",")
    end

    puts "commas: #{comma}"
    puts "no_comma: #{no_comma}"

#commas: [["7041", "1mm, 2mm, 3mm"], ["7040", "Black, White, Grey"]]
#no_comma: {"7043"=>"Linso"}

# Transform ["7041", "1mm, 2mm, 3mm"] to:
# {"7043"=>
#  [
#   [{"7043"=>"Linso"},{"7041"=>"1mm"}],
#   [{"7043"=>"Linso"},{"7041"=>"2mm"}],
#   [{"7043"=>"Linso"},{"7041"=>"3mm"}]
#  ],
#  "7040"=>
#  [
#   [{"7040"=>"Linso"},{"7040"=>"Black"}],
#   [{"7040"=>"Linso"},{"7040"=>"White"}],
#   [{"7040"=>"Linso"},{"7040"=>"Grey"}]
#  ]
# }


    comma.each do | attrib, val | 
      ary = val.strip.squeeze(",").squeeze(" ").split(',')
      ary.each do | ary_val |
        tmp = no_comma.clone
        tmp[attrib] = ary_val
        stage_2[attrib] ||= []
        stage_2[attrib] << tmp
      end
    end if comma


    puts "STAGE 2: #{stage_2}"

    stage_3 = []

    


    comma.each do | attrib, val | 
      
        ary = val.strip.squeeze(",").squeeze(" ").split(',')
        puts "Processing Attrib: #{attrib}, ary: #{ary}"

        others = stage_2.reject {|a,v| a == attrib}
        puts "Others: #{others}"

        ary.each do | ary_val |
          others.each do | o_key, array_of_hash | 
            array_of_hash.each do |hash| 
              hash[attrib] = ary_val.strip
              puts "Updated: #{o_key}, with: #{hash[attrib]} "
              stage_3 << hash.clone
            end
          end
        end
      
    end    

    puts "STAGE 3: #{stage_3}"



    # stage_2.each do | attrib, val_array |
    #   puts "Processing Attrib: #{attrib}, val_array: #{val_array}"
    #   others = stage_2.reject {|a,v| a == attrib}
    #   puts "Others: #{others}"
    #   val_array.each do | val |
    #     others.each do | o_key, array_of_hash | 
    #       array_of_hash.each { |hash| hash[attrib] = val}
    #     end
    #   end
    #   puts "Others After: #{others}"
    # end

    
    


    modified_item_parms = create_attrib_item_values
    modified_item_parms = handle_new_item_base_add_supplier(modified_item_parms)

    @item = Item.new(modified_item_parms)
    if @item.save
      @items = Item.active
      flash[:success] = "Saved '#{@item.name}'"
      render 'index'
    else
      render 'new'
    end
  end

  def update
    modified_item_parms = create_attrib_item_values
    modified_item_parms = handle_new_item_base_add_supplier(modified_item_parms)
    @item.update(modified_item_parms)
    respond_with(@item)
  end

  def destroy
    if @item.destroy
      flash[:notice] = "Deleted '#{@item.name}'"
    else
      flash[:error] = "Error while deleting '#{@item.name}'"
    end
      respond_with(@item)
  end

  private
    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :item_base_name, :item_base_id, :supplier_id, :description, :unit)
    end
end
