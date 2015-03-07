module PurchaseOrdersHelper
  def show(purchase_order, status)
    if purchase_order && @status == 'DELETED'
      return true
    else
      purchase_order && purchase_order.destroyed? == false && purchase_order.status != 'DELETED' && @status != 'DELETED'
    end
  end

  def can_confirm(purchase_order)
    purchase_order && purchase_order.status != 'CONFIRMED'
  end

  def render_menu(purchase_order, menu_name)
    render partial: "purchase_orders/show/#{menu_name}", locals: {purchase_order: purchase_order}
  end
end
