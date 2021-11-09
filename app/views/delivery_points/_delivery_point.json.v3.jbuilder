json.cache! delivery_point do
  json.extract! delivery_point, :id, :latitude, :longitude
  json.provider_name delivery_point.provider.name
end
