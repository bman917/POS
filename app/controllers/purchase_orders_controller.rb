class PurchaseOrdersController < ApplicationController
  before_action :set_purchase_order, only: [:show, :edit, :update, :destroy, :confirm, :pending]
  before_action :last_purchase_order, only: [:add_items, :index]

  respond_to :html, :js

  def last_purchase_order
    @purchase_order = PurchaseOrder.where(supplier: selected_supplier, status: 'PENDING').last
  end

  def add_items
    
    unless @purchase_order
      @purchase_order = PurchaseOrder.create(supplier_id: selected_supplier, status: 'PENDING')
    end

    items = params[:items]
    items.each do |i|
      
      if (true if Float(i[:qty]) rescue false)
        puts "Item: ID=#{i[:id]}, QTY=#{i[:qty]}"
        ipo = ItemPurchaseOrder.new(item_id: i[:id], 
          purchase_order_id: @purchase_order.id, 
          quantity: i[:qty])
        @purchase_order.item_purchase_orders << ipo  
      end
    end
    @purchase_order.save!
    render 'show'
  end

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

  def column_names
    %w(name unit pending_orders input)
  end

  def index
    purchase_order_list
    session[:status] = 'PENDING'

    @items_datatable = items_datatable

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
