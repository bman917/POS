class Sale < ActiveRecord::Base
	has_many :item_sales, dependent: :destroy

	def number
		"S#{format('%02d', created_at.month)}#{created_at.year}#{format('%07d', id)}"
	end
end