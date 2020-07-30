json.cache! delivery_point, expires_in: delivery_point.expires_in do
  json.extract! delivery_point,
                :address, :code, :date_interval, :directions,
                :estimate_delivery_date, :estimated_delivery_date,
                :latitude, :longitude, :name, :phone_number, :uuid

  json.working_hours format_working_hours(delivery_point)

  json.provider do
    json.partial! 'providers/provider', provider: delivery_point.delivery_method.provider
  end
end
