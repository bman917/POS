class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy, :confirm, :pending]

  respond_to :html, :js

  def pending
    @purchase_order.status = "PENDING"
    if @purchase_order.save
      flash[:status] = "PO Status Updated"
    else
      flash[:error] = "PO Status Update Failed"
    end

    purchase_order_list
  end

  def confirm
    @purchase_order.status = "CONFIRMED"
    if @purchase_order.save
      flash[:status] = "PO Status Updated"
    else
      flash[:error] = "PO Status Update Failed"
    end

    purchase_order_list
  end


  def index
    purchase_order_list

    respond_to do | format |
      format.html
      format.js
    end
  end

  def show
    respond_to do | format |
      format.html do
        purchase_order_list
        render 'index'
      end

      format.js { selected_status }
    end
    
  end

  def new
    @purchase_order = PurchaseOrder.new(
      status: 'PENDING',
      date: Date.today,
      supplier_id: params[:supplier_id])
    @purchase_order.save

    respond_to do | format |
      format.html
      format.js
    end
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
    @purchase_order.status = 'DELETED'
    @purchase_order.save!

    purchase_order_list

    respond_to do | format |
      format.html do
        purchase_order_list
        render 'index'
      end
      
      format.js
    end
  end

  private
    def set_purchase_order
      @purchase_order = PurchaseOrder.find_by(id: params[:id])
    end

    def purchase_order_params
      params.require(:purchase_order).permit(:supplier_id, :status, :notes, :date)
    end


end
