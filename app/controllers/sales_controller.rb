class SalesController < ApplicationController
  respond_to :html, :js

  def report_by_month
    date = Date.parse(params[:date])
    start_date = date.beginning_of_month.prev_day
    end_date   = date.end_of_month.next_day

    @sales_by_date = Sale.where("status = 'COMPLETED' AND created_at between ? and ?", start_date, end_date).order(:created_at).group("DATE(created_at)").count


    @month = date.strftime("%b %Y")
  end

  def report_by_date
    @d = Date.parse(params[:date])
    bod = @d.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
    eod = @d.end_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")

    sale_ids = Sale.where("status = 'COMPLETED' AND created_at between ? and  ?", bod, eod).map{|i| i.id}
    @transactions = sale_ids.count
    @total = Sale.where(id: sale_ids).sum(:total)
    puts sale_ids
    @item_sales = ItemSale.where(sale_id: sale_ids).includes(:item)
    @item_summary = {}
    @item_sales.each do |item_sale|
      name = item_sale.item.name
      count = item_sale.qty + (@item_summary[name] || 0)
      puts "#{name} - #{count}"
      @item_summary[name] = count
    end



    # @item_sales = ItemSale.where(sale_id: sale_ids).group(:item_id).count

    # item_ids = @item_sales.map { |is| is.first }
    # @items = Item.where(id: item_ids)
    # @items.each do |i|
    #   # if @item_sales[i.id]
    #     name = i.name
    #     count = @item_sales[i.id]
    #     @item_summary[name] = [] unless @item_summary[name]
    #     @item_summary[name] << 
    #   # end
    # end
    # puts @item_sales



  end

  def report
    @dates = []
    first_sale_date = Sale.order('created_at asc').first.created_at
    tmp = Date.today.prev_year

    1.upto(12) do
      tmp = tmp.next_month
      @dates << tmp if tmp >= first_sale_date
    end

    @reports = []
    @dates.each do |date|
      start_date = date.beginning_of_month.strftime("%Y-%m-%d")
      end_date   = date.end_of_month.strftime("%Y-%m-%d")
      @reports << Report.find_or_create_by(start_date: start_date, 
        end_date: end_date)
    end

    @reports.each do |r|
      unless r.number_of_sales
        r.number_of_sales = Sale.where("status = 'COMPLETED' created_at between ? and ?", r.start_date, r.end_date).count
        r.save! if r.number_of_sales
      end
    end
    
    @sales_by_date_q = Sale.order(:created_at).group("DATE(created_at)")
    @month = @sales_by_date_q.group_by{ |r| r.created_at.month }
    @sales_by_date = @sales_by_date_q.count
    puts @dates
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