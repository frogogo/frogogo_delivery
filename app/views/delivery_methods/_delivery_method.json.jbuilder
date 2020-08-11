json.cache! delivery_method, expires_in: delivery_method.expires_in do
  json.extract! delivery_method,
                :courier_delivery_dates,
                :estimate_delivery_date, :estimated_delivery_date,
                :date_interval, :method, :time_intervals

  if delivery_method.provider.name == 'RussianPost'
    json.estimate_delivery_date delivery_method.date_interval
    json.estimated_delivery_date delivery_method.date_interval
  end

  json.provider do
    json.partial! 'providers/provider', provider: delivery_method.provider
  end
end
