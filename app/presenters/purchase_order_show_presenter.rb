class PurchaseOrderShowPresenter < BasePresenter
  presents :purchase_order
  
  def render_menu(menu_name)
    render partial: "purchase_orders/show/#{menu_name}", locals: {purchase_order: purchase_order}
  end

end