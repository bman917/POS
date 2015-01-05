json.array!(@items) do |item|
  json.extract! item, :id, :item_base_id, :supplier_id, :description, :unit
  json.url item_url(item, format: :json)
end
