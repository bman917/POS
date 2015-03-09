class DeliveryItemsController < ApplicationController

  def autocomplete
  end

  def create
    @delivery_item = DeliveryItem.new(delivery_item_params)
    
    unless @delivery_item.save
      flash[:error] = "Save failed. #{@delivery_item.errors.full_messages}"
    end

    @delivery = @delivery_item.delivery

    render 'deliveries/show'
  end

  private
    def delivery_item_params
      params.require(:delivery_item).permit(:item_id, :delivery_id, :purchase_order_id, :quantity)
    end
end
