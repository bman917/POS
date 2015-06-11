class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  def items_datatable
    items_datatable = ItemsDatatable.new(view_context, 
      column_names, supplier: selected_supplier)
  end

  def selected_supplier
    @supplier_id = params[:supplier_id] || session[:supplier_id] || Supplier.all.first.id
    session[:supplier_id] = @supplier_id
  end

  def clear_selected_supplier
    session[:supplier_id] = nil
  end

  def selected_status
    puts "session status: #{session[:status]}"
    @status = params[:status] || session[:status] || 'PENDING'
    session[:status] = @status
  end

  private

  def purchase_order_list
    @status = selected_status
    @supplier_id = selected_supplier
    @purchase_orders = PurchaseOrder.where(status: @status, supplier: @supplier_id).includes(:supplier).order(id: :desc, date: :desc).paginate(:page => params[:page])
  end

  def delivery_list
    @status = selected_status
    @supplier_id = selected_supplier
    @deliveries = Delivery.where(supplier: @supplier_id).includes(:supplier).order(id: :desc, date: :desc).paginate(:page => params[:page])
    purchase_orders = PurchaseOrder.where(supplier: @supplier_id, status: 'CONFIRMED' )
    @purchase_order_items = ItemPurchaseOrder.where(purchase_order: purchase_orders)
  end

end
