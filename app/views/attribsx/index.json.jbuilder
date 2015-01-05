json.array!(@attribs) do |attrib|
  json.extract! attrib, :id, :name
  json.url attrib_url(attrib, format: :json)
end
