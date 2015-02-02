class ItemPurchaseOrdersController < ApplicationController

  respond_to :html, :js

  def destroy_multiple
    begin
      ret_val = ItemPurchaseOrder.destroy_all(id: params[:item_purchase_order_ids])
      flash[:status] = "Successfully Deleted #{ret_val.size} #{"item".pluralize(ret_val.size)}"
      @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
      
      respond_to do | format |
        format.html do 
          purchase_order_list
          render 'purchase_orders/index', flash: flash
        end

        format.js do
          render 'purchase_orders/show', flash: flash
        end
      end

    rescue Exception => e
      flash[:error] = "Unexpected error while deleting Items: #{e.message}"
    end
  end

  def autocomplete
  end

  def create
    @item_purchase_order = ItemPurchaseOrder.new(item_purchase_order_params)
    
    unless @item_purchase_order.save
      flash[:error] = "Save failed. #{@item_purchase_order.errors.full_messages}"
    end

    @purchase_order = @item_purchase_order.purchase_order

    render 'purchase_orders/show'
  end

  private
    def item_purchase_order_params
      params.require(:item_purchase_order).permit(:item_id, :purchase_order_id, :quantity)
    end

end
