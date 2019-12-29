json.cache! delivery_method, expires_in: Time.current.end_of_day - Time.current do
  json.extract! delivery_method,
                :id, :date_interval, :inactive,
                :method, :time_intervals

  json.provider do
    json.partial! 'providers/provider', provider: delivery_method.provider
  end
end
