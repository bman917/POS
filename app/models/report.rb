class Report < ActiveRecord::Base
	def to_s
		Date.parse(start_date).strftime("%b %Y")
	end
end
