class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def add_attrib
    @attribs = Attrib.where(id: params[:attrib])
  end

  def index
    @items = Item.all
    respond_with(@items)
  end

  def show
    respond_with(@item)
  end

  def new
    @item = Item.new(item_base: ItemBase.new)
    @attribs = [Attrib.first]

    respond_with(@item)
  end

  def edit
    @item = set_item
    @base_attribs = @item.attrib_values
  end

  def handle_new_item_base_abd_supplier(params)
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
  #the form. At this point these Attribs-Values may not yet be 
  #associated to the ItemBase. The following logic handles this
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

  def create
    modified_item_parms = create_attrib_item_values
    modified_item_parms = handle_new_item_base_abd_supplier(modified_item_parms)

    @item = Item.new(modified_item_parms)
    @item.save
    respond_with(@item)
  end

  def update
    modified_item_parms = create_attrib_item_values
    modified_item_parms = handle_new_item_base_abd_supplier(modified_item_parms)
    @item.update(modified_item_parms)
    respond_with(@item)
  end

  def destroy
    @item.destroy
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
