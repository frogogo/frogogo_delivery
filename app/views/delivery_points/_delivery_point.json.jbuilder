json.cache! delivery_point, expires_in: delivery_point.expires_in do
  json.extract! delivery_point,
                :address, :code, :date_interval,
                :estimate_delivery_date, :estimated_delivery_date,
                :latitude, :longitude, :name, :phone_number, :uuid, :working_hours

  json.working_hours format_working_hours(delivery_point) if delivery_point.provider.name == 'RussianPost'
  json.directions delivery_point.directions unless delivery_point.provider.name == 'RussianPost'
  json.provider do
    json.partial! 'providers/provider', provider: delivery_point.delivery_method.provider
  end
end
