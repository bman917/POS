class ItemSalesController < ApplicationController

  respond_to :html, :js

  def create
    @item_sale = ItemSale.new(item_sale_params)
    @item_sale.save!

    @sale = @item_sale.sale

    render 'sales/item_sales/create'
  end

  def destroy_multiple
    begin
      @item_sales = params[:item_sale_id]
      ret_val = ItemSale.destroy_all(id: @item_sales)
      flash[:status] = "Successfully Deleted #{ret_val.size} Sales Items"
    rescue Exception => e
      flash[:error] = "Unexpected error while deleting Sales Items: #{e.message}"
    end
    @sale = Sale.find(params[:sale_id])
    
    # render 'sales/new'
  end

  private
  def item_sale_params
    params.require(:item_sale).permit(:item_id, :qty, :sale_id, :price)
  end
end