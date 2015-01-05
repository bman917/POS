class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def add_attribute
    @attributes = Attribute.where(id: params[:attribute])
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
    @attributes = [Attribute.first]

    respond_with(@item)
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    @base_attrbs = []

    @attributes = params[:Attribute]
    puts "Keys: #{@attributes.keys}..."
    @attributes.keys.each do | key |
      puts "Creating ItemAttributeValue for #{key}..."
      @base_attrbs << ItemAttributeValue.new(attribute_id: key, value: @attributes[key])
    end


    puts "Attributes: #{@attributes}, @base_attrbs: #{@base_attrbs.size}"
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
      params.require(:item).permit(:item_base_id, :supplier_id, :description, :unit)
    end
end
