module PurchaseOrdersHelper
	def show(purchase_order, status)
		if purchase_order && @status == 'DELETED'
			return true
		else
			purchase_order && purchase_order.destroyed? == false && purchase_order.status != 'DELETED' && @status != 'DELETED'
		end
	end
end
