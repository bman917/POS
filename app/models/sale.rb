class Sale < ActiveRecord::Base
  scope :in_progress, -> { where("status = 'NEW' AND created_at >= ?", Time.zone.now.beginning_of_day).order(created_at: :desc)}
  scope :completed, -> { where("status = 'COMPLETED' AND created_at >= ?", Time.zone.now.beginning_of_day).order(created_at: :desc)}
  has_many :item_sales, dependent: :destroy

  def number
    "S#{format('%02d', created_at.month)}#{created_at.strftime('%y')}#{format('%05d', id)}"
  end

  def age
    Time.now - self.created_at
  end

  def change_to_tender
    retVal = 0
    retVal = self.payment_1 - self.total if self.payment_1 && self.total
    retVal = 0 if retVal < 0
    retVal
  end

  def self.in_between(start_date, end_date)
      sale_ids = Sale.where("status = 'COMPLETED' AND created_at between ? and  ?", 
        start_date, end_date)
  end

  def self.within_month(date)
      start_date = date.beginning_of_month
      end_date   = date.end_of_month.next_day
      Sale.in_between(start_date, end_date)
  end

  def self.within_day(date)
    bod = date.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
      eod = date.end_of_day.strftime("%Y-%m-%d %H:%M:%S:%L")
      Sale.in_between(bod, eod)
  end

  def self.generate_summary(start_date, end_date)
    map = {}
    map[:sale_ids] = Sale.in_between(start_date, end_date).map{|i| i.id}
    map[:transactions] = map[:sale_ids].count
    map[:total] = Sale.where(id: map[:sale_ids]).sum(:total)

    item_count = {}
    item_sales = ItemSale.where(sale_id: map[:sale_ids]).includes(:item)
    item_sales.each do |item_sale|
      name = item_sale.item.name
      count = item_sale.qty + (item_count[name] || 0)
      item_count[name] = count
    end
    map[:item_count] = item_count

    return map
  end
end