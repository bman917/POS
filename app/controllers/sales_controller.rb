class SalesController < ApplicationController
  respond_to :html, :js

  def report_list
    self.show
  end

  def report_by_month
    date = Date.parse(params[:date])
    
    start_date = date.beginning_of_month
    end_date   = date.end_of_month.next_day
    @summary = Sale.generate_summary(start_date,end_date)
    
    @sales_by_date = Sale.within_month(date).order(:created_at).group("DATE(created_at)").count

    @month = date.strftime("%b %Y")
    render layout: 'application'
  end

  def report_by_date
    @d = Date.parse(params[:date])
    bod = @d.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
    eod = @d.end_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
    @summary = Sale.generate_summary(bod,eod)
    render layout: 'application'
  end

  def report
    @dates = []
    first_sale_date = Sale.order('created_at asc').first.created_at
    tmp = Date.today.prev_year

    1.upto(12) do
      tmp = tmp.next_month
      @dates << tmp if tmp >= first_sale_date
    end

    puts "Getting report for #{@dates}......"

    @reports = []
    @dates.each do |date|
      start_date = date.beginning_of_month.strftime("%Y-%m-%d")
      end_date   = date.end_of_month.strftime("%Y-%m-%d")
      r = Report.find_or_create_by(start_date: start_date, 
        end_date: end_date)
      puts "Found Report: #{r}"
      @reports << r #if r.number_of_sales && r.number_of_sales > 0
    end

    puts "Total Reports found #{@reports}"

    @reports.each do |r|
      unless r.number_of_sales
        r.number_of_sales = Sale.in_between(r.start_date, r.end_date).count
        r.save! if r.number_of_sales && r.number_of_sales > 0
      end
    end
    
    @sales_by_date_q = Sale.order(:created_at).group("DATE(created_at)")
    @month = @sales_by_date_q.group_by{ |r| r.created_at.month }
    @sales_by_date = @sales_by_date_q.count
    puts @dates
    render layout: 'application'
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

  def create_new
    @sale = Sale.in_progress.first
    if @sale && @sale.item_sales.count > 0
      create_and_store_in_session
      session[:current_sale_id] = @sale.id
    end
    set_sales_list
    render layout: "sales", action: 'new'
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
    render layout: "sales"
  end

  def show
    @sale = set_sale
    set_sales_list
  end

  def destroy_no_auto_create
    @sale = set_sale
    @sale.destroy
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