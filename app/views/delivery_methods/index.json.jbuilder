json.delivery_methods do
  json.array! @delivery_methods, partial: 'delivery_method', as: :delivery_method
end

json.delivery_zone do
  json.partial! '/delivery_zones/delivery_zone', delivery_zone: @delivery_zone
end
