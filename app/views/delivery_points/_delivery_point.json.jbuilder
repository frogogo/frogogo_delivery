json.cache! delivery_point, expires_in: delivery_point.expires_in do
  json.extract! delivery_point,
                :address, :code, :date_interval, :directions,
                :estimate_delivery_date, :estimated_delivery_date,
                :latitude, :longitude, :name, :phone_number, :uuid, :working_hours

  if delivery_point.provider.name == 'RussianPost'
    json.working_hours format_working_hours(delivery_point)
    json.estimate_delivery_date delivery_point.date_interval
    json.estimated_delivery_date delivery_point.date_interval
  end

  json.provider do
    json.partial! 'providers/provider', provider: delivery_point.delivery_method.provider
  end
end
