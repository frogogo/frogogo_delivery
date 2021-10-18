json.cache! delivery_point, expires_in: 10.minutes do
  json.extract!(
    delivery_point,
    :latitude,
    :longitude
  )
  json.provider_name delivery_point.provider.name
end
