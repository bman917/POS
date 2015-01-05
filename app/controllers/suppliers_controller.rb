class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  respond_to :html

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
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      @suppliers = Supplier.all
      render 'index'
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