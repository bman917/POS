class SalesController < ApplicationController
  respond_to :html, :js

  def report_by_date
    @d = Date.parse(params[:date])
    bod = @d.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
    eod = @d.end_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")

    sale_ids = Sale.where("status = 'COMPLETED' AND created_at between ? and  ?", bod, eod).map{|i| i.id}
    @transactions = sale_ids.count
    @total = Sale.where(id: sale_ids).sum(:total)
    @item_sales = ItemSale.where(sale_id: sale_ids).group(:item_id).count
    item_ids = @item_sales.map { |is| is.first }
    @items = Item.where(id: item_ids)
    @item_summary = {}
    @items.each do |i|
      # if @item_sales[i.id]
        count = @item_sales[i.id]
        name = i.name
        @item_summary[name] = count
      # end
    end
    puts @item_summary

  end

  def report
    @sales_by_date_q = Sale.order(:created_at).group("DATE(created_at)")
    @sales_by_date = @sales_by_date_q.count
  end

  def set_customer
    @sale = set_sale
    @sale.customer_name = params[:customer_name]
    @sale.save!
  end

  def payment
    @sale = set_sale
    @sale.payment_1 = params[:amount].to_f
    @sale.save!
  end

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
    @sale = Sale.in_progress.first

    if @sale && @sale.created_at.day < Time.now.day
      if @sale.item_sales.count == 0
        @sale.destroy
        @sale = nil
      end
    end
    
    create_and_store_in_session unless @sale
    session[:current_sale_id] = @sale.id
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
    @sale
  end

  def create_and_store_in_session
    @sale = Sale.create(status: "new", customer_name: 'CASH', created_by: current_user.username)
    session[:current_sale_id] = @sale.id
    @sale
  end
end