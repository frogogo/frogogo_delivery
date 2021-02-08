json.delivery_methods do
  json.array! @delivery_methods, partial: 'delivery_method', as: :delivery_method
end

json.cache! @delivery_points do
  json.delivery_points do
    json.array! @delivery_points, partial: 'delivery_points/delivery_point', as: :delivery_point
  end
end

json.delivery_zone do
  json.partial! 'delivery_zones/delivery_zone', delivery_zone: @delivery_zone
end
