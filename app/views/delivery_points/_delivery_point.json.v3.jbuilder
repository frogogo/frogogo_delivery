json.cache! delivery_point do
  json.extract! delivery_point, :latitude, :longitude
  json.provider_name delivery_point.provider.name
end
