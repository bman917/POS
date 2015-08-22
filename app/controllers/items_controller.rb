class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def sales
  end


  def autocomplete
  end

  def column_names
    %w(check_box name unit supplier pending_orders copy edit)
  end


  def json
    
    @column_names = column_names
    @items_datatable = ItemsDatatable.new(view_context, @column_names)
    
    if params[:term]
      #When there is a :term paramter then it means this is an autocomplete json
      render json: ItemsAutocomplete.new(view_context)
    else
      render json: @items_datatable
    end
  end

  def json_filter_by_supplier
    
    @column_names = column_names
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

  def set_multiple_price

    ids = params[:item_ids]
    Item.transaction do

      name = params[:price_type]

      params[:item_ids].each do | item_id |
        item_price = ItemPrice.where(item_id: item_id, name: name).first

        unless item_price
          item_price = ItemPrice.new(item_id: item_id, name: name)
        end

        item_price.price = params[:price_value]
        item_price.save!
      end

      flash[:status] = "Successfully Updated #{name} Price of #{ids.size} Items"
    end if ids 

    render_index

  end

  def destroy_multiple
    begin
      ret_val = Item.destroy_all(id: params[:item_ids])
      flash[:status] = "Successfully Deleted #{ret_val.size} Items"
    rescue Exception => e
      flash[:error] = "Unexpected error while deleting Items: #{e.message}"
    end
    render_index
  end

  def add_attrib
    @attribs = Attrib.where(id: params[:attrib]).order(:display_number)
  end

  def index
    render_index
  end

  def index_switch_supplier
    prepare_index
    respond_to do |format|
      format.html { render 'index' }
      format.js { render 'reload_data_table'}
    end
  end

  def index_switch_item_base
    @column_names = %w(summary price_summary supplier)
    @items_datatable = ItemsDatatable.new(view_context, @column_names, {:items => selected_item_base})
    respond_to do |format|
      format.html { render 'index' }
      format.js { render 'reload_data_table'}
    end
  end

  def show
    @cloned_item = Item.new(@item.attributes)
    respond_with(@item)
  end

  def new
    @item = Item.new(item_base: ItemBase.new)
    @item.supplier_id = selected_supplier
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
  def create_item_params(attribs) 
    @base_attribs = []
    @attribs = attribs
    @attribs.keys.each do | key |
      @base_attribs << AttribItemValue.new(attrib_id: key, value: @attribs[key])
      #puts "AttribItemValue: #{@base_attribs.last.attrib.id}, #{@base_attribs.last.value}"
    end if @attribs
    #puts "Attribs: #{@attribs}, @base_attribs: #{@base_attribs.size}"
    modified_item_parms = item_params
    modified_item_parms[:attrib_values] = @base_attribs
    modified_item_parms[:pending_orders] = 0
    handle_new_item_base_add_supplier(modified_item_parms)
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

    new_items = []
    attribs = ItemsHelper.generate_attribs(orig_attribs)
    attribs.each do |attrib|
      item_params_with_attrib_item_values = create_item_params(attrib)
      new_items << Item.new(item_params_with_attrib_item_values)
    end

    # modified_item_parms = create_attrib_item_values
    # modified_item_parms = handle_new_item_base_add_supplier(modified_item_parms)
    # modified_item_parms[:pending_orders] = 0
    # @item = Item.new(modified_item_parms)

    Item.transaction do
      new_items.each do |item| 
        @item = item
        item.save! 
      end
       flash[:success] = "Successfully Created #{new_items.size} Items"
    end

    
    render_index

   rescue ArgumentError => a
      @item = Item.new(item_params)
      @item.errors.add(:commas, ': Only one attribute is allowed comma-delimited values.')
      render 'new'
   rescue ActiveRecord::RecordInvalid => e
      render 'new'
  end

  def update
    modified_item_parms = create_attrib_item_values
    modified_item_parms = handle_new_item_base_add_supplier(modified_item_parms)
    @item.assign_attributes(modified_item_parms)
    
    unless @item.changed && @item.save
      render 'edit'
      return
    end

    flash[:success] = "Saved '#{@item.name}'"
    render_index

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
    def prepare_index
      @supplier_id = item_params[:supplier_id] if (params && params[:item])
      @supplier_id ||= selected_supplier
      @column_names = %w(check_box summary price_summary copy edit)
      @items_datatable = ItemsDatatable.new(view_context, @column_names)
    end
    def render_index
      prepare_index
      render 'index'
    end

    def set_item
      @item = Item.find(params[:id])
    end

    def item_params
      params.require(:item).permit(:name, :item_base_name, :item_base_id, :supplier_id, :description, :unit)
    end
end
