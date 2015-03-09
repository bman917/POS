json.array!(@deliveries) do |delivery|
  json.extract! delivery, :id, :date, :supplier_id, :supplier_dr_number, :notes
  json.url delivery_url(delivery, format: :json)
end
