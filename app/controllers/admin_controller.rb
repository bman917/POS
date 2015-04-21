class AdminController < ApplicationController
  def reset_purchase_orders
  	Item.update_all( pending_orders: 0)
  	redirect_to items_url
  end
end
