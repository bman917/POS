class Delivery < ActiveRecord::Base
  belongs_to :supplier
  has_many :delivery_items

  def date_short_format
    date.to_time.to_s(:med) if date
  end
end
