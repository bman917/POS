class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!


  def selected_supplier
    @supplier_id = params[:supplier_id] || session[:supplier_id] || Supplier.all.first.id
    session[:supplier_id] = @supplier_id
  end

  def selected_status
    @status = params[:status] || session[:status] || 'PENDING'
    session[:status] = @status
  end

end
