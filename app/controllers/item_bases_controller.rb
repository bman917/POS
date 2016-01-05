class ItemBasesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:script_to_add_to_select]
  before_action :set_item_base, only: [:show, :edit, :update, :destroy]

  respond_to :html

  #Returns attribs of an item base
  #Used by: item_form
  def scripts_to_add_attribs_to_item_form
    if params[:id] && params[:id] != "-1"
      @item_base = set_item_base
      @attribs = @item_base.attribs
    end
  end

  # This is triggered from the add item form.
  # It loads the new ItemBase from
  def add_to_new_item_form
    @item_base = ItemBase.new
    @modified_url = item_base_script_to_add_to_select_path
    @remote = true
    render 'new', layout: false
  end

  # Triggers the javascript that will add the new item base
  # into a select box. Used after the add_to_new_item_form action
  def script_to_add_to_select
    @item_base = ItemBase.new(item_base_params)
    respond_to { | format | format.js }
  end

  def index
    @item_bases = ItemBase.all
    respond_with(@item_bases)
  end

  def show
    respond_with(@item_base)
  end

  def new
    @item_base = ItemBase.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @item_base = ItemBase.new(item_base_params)
    @item_base.save
    respond_with(@item_base)
  end

  def update
    @item_base.update(item_base_params)
    respond_with(@item_base)
  end

  def destroy
    @item_base.destroy
    respond_with(@item_base)
  end

  private
    def set_item_base
      @item_base = ItemBase.find(params[:id])
    end

    def item_base_params
      params.require(:item_base).permit(:name)
    end
end
