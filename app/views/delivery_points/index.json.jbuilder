json.delivery_points do
  json.array! @delivery_points, partial: 'delivery_point', as: :delivery_point
end
