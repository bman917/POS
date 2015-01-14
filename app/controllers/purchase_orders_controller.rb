class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index

    @status = params[:status] || 'PENDING'
    @supplier_id = params[:supplier_id] || Supplier.all.first.id


    @purchase_orders = PurchaseOrder.where(status: @status, supplier: @supplier_id).includes(:supplier)
    @purchase_order = PurchaseOrder.first

    respond_to do | format |
      format.html
      format.js
    end
  end

  def show
    respond_to do | format |
      format.html
      format.js
    end
  end

  def new
    @purchase_order = PurchaseOrder.new(status: 'PENDING')
    respond_with(@purchase_order)
  end

  def edit
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.save
    @purchase_orders = PurchaseOrder.all
    render 'index'
  end

  def update
    @purchase_order.update(purchase_order_params)
    respond_with(@purchase_order)
  end

  def destroy
    @purchase_order.destroy
    respond_with(@purchase_order)
  end

  private
    def set_purchase_order
      @purchase_order = PurchaseOrder.find(params[:id])
    end

    def purchase_order_params
      params.require(:purchase_order).permit(:supplier_id, :status, :notes, :date)
    end
end
