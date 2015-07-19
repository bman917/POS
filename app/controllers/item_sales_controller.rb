class ItemSalesController < ApplicationController

  def create
    @item_sale = ItemSale.new(item_sale_params)
    @item_sale.save!
    render 'sales/item_sales/create'
  end

  private
  def item_sale_params
    params.require(:item_sale).permit(:item_id, :qty, :sale_id, :price)
  end
end