json.extract!(
  delivery_point,
  :id,
  :latitude,
  :longitude
)
json.provider_name delivery_point.provider.name
