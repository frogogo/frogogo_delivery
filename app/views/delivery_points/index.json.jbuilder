json.cache! @delivery_points do
  json.delivery_points do
    json.array! @delivery_points, partial: 'delivery_point_short', as: :delivery_point
  end
end
