json.cache! delivery_method, expires_in: Time.current.end_of_day - Time.current do
  json.extract! delivery_method,
                :courier_delivery_dates, :estimate_delivery_date,
                :date_interval, :method, :time_intervals

  json.provider do
    json.partial! 'providers/provider', provider: delivery_method.provider
  end
end
