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
  end

  def create

    @base_attribs = []
    @attribs = params[:attrib]
    @attribs.keys.each do | key |
      @base_attribs << AttribItemValue.new(attrib_id: key, value: @attribs[key])
      puts "AttribItemValue: #{@base_attribs.last.attrib.id}, #{@base_attribs.last.value}"
    end if @attribs
    puts "Attribs: #{@attribs}, @base_attribs: #{@base_attribs.size}"
    p = item_params
    p[:attrib_values] = @base_attribs
    @item = Item.new(p)
    @item.save
    respond_with(@item)
  end

  def update
    @item.update(item_params)
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
      params.require(:item).permit(:item_base_name, :item_base_id, :supplier_id, :description, :unit)
    end
end
