json.cache! delivery_point, expires_in: Time.current.end_of_day - Time.current do
  json.extract! delivery_point,
                :id, :address, :code, :directions, :latitude,
                :longitude, :phone_number, :working_hours
end
