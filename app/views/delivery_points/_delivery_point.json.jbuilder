json.cache! delivery_point, expires_in: Time.current.end_of_day - Time.current do
  json.extract! delivery_point,
                :address, :code, :directions, :latitude,
                :longitude, :name, :phone_number, :working_hours

  json.provider do
    json.partial! 'providers/provider', provider: delivery_point.delivery_method.provider
  end
end
