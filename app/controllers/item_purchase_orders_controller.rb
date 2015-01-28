class ItemPurchaseOrdersController < ApplicationController

  respond_to :html, :js

  def autocomplete
  end

  def create
    @item_purchase_order = ItemPurchaseOrder.new(item_purchase_order_params)
    if @item_purchase_order.save
      @purchase_order = @item_purchase_order.purchase_order
      render 'purchase_orders/show'
    else
      render 'error'
    end
  end

  private
    def item_purchase_order_params
      params.require(:item_purchase_order).permit(:item_id, :purchase_order_id, :quantity)
    end

end
