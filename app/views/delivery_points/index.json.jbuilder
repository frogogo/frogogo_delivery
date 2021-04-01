json.cache! @delivery_points, expires_in: 10.minutes do
  json.delivery_points do
    json.array! @delivery_points, partial: 'delivery_point', as: :delivery_point
  end
end
