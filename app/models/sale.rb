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
end