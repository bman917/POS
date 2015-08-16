class SalesController < ApplicationController
  respond_to :html, :js

  def new_item
  end

  def close
    current_sale = set_sale
    current_sale.status = 'COMPLETED'
    current_sale.save!

    @sale = create_and_store_in_session
    set_sales_list

    render 'new'
  end

  def new
    @sale = Sale.find_by_id(session[:current_sale_id])
    create_and_store_in_session unless @sale
    set_sales_list
  end

  def show
    @sale = set_sale
    set_sales_list
  end

  def destroy
    @sale = set_sale
    @sale.destroy
    set_sales_list
    create_and_store_in_session
  end

  private

  def set_sales_list
    set_sale_in_progress
    set_completed_sales
  end

  def set_sale_in_progress
    @sales_in_progress = Sale.in_progress.where(created_by: current_user.username)
  end

  def set_completed_sales
    @completed_sales = Sale.completed.where(created_by: current_user.username).limit(10)
  end

  def set_sale
    @sale = Sale.find(params[:id])
  end

  def create_and_store_in_session
    @sale = Sale.create(status: "new", created_by: current_user.username)
    session[:current_sale_id] = @sale.id
    @sale
  end
end