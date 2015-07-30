class SalesController < ApplicationController
  respond_to :html, :js

  def new_item
  end

  def new
    @sale = Sale.find_by_id(session[:current_sale_id])
    create_and_store_in_session unless @sale
  end

  def destroy
    @sale = set_sale
    @sale.destroy
    create_and_store_in_session
  end

  private
  def set_sale
    @sale = Sale.find(params[:id])
  end

  def create_and_store_in_session
    @sale = Sale.create
    session[:current_sale_id] = @sale.id
  end
end