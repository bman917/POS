json.array!(@item_bases) do |item_base|
  json.extract! item_base, :id, :name
  json.url item_base_url(item_base, format: :json)
end
