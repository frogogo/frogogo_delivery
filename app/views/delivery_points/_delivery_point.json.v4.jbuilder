json.cache! delivery_point do
  json.extract!(
    delivery_point,
    :address,
    :id,
    :latitude,
    :longitude,
    :name
  )
  json.provider_name delivery_point.provider.name
end
