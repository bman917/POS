class SuppliersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:script_to_add_to_select]
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def add_to_new_item_form
    @supplier = Supplier.new
    @modified_url = supplier_script_to_add_to_select_path
    @remote = true
    render 'new', layout: false
  end

  def script_to_add_to_select
    @supplier = Supplier.new(supplier_params)
    respond_to { | format | format.js }
  end

  def index
    @suppliers = Supplier.all
    respond_with(@suppliers)
  end

  def show
    respond_with(@supplier)
  end

  def new
    @supplier = Supplier.new
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    puts "request.referer: #{request.referer.end_with?('items')}"
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      session[:supplier_id] = @supplier.id
      flash[:success] = "Successfully created Supplier: #{@supplier.name}"
      redirect_to '/items'
    else
      respond_with(@supplier)
    end
  end

  def update
    @supplier.update(supplier_params)
    @suppliers = Supplier.all
    render 'index'
  end

  def destroy
    @supplier.destroy
    clear_selected_supplier
    respond_with(@supplier)
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:name)
    end
end
