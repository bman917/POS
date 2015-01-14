json.array!(@purchase_orders) do |purchase_order|
  json.extract! purchase_order, :id, :supplier_id, :status, :notes, :date
  json.url purchase_order_url(purchase_order, format: :json)
end
