class SalesController < ApplicationController
	def new_item
	end

	def new
		@sale = Sale.find_by_id(session[:current_sale_id])
		unless @sale
			@sale = Sale.create
			session[:current_sale_id] = @sale.id
		end
	end
end