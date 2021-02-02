json.cache! delivery_method, expires_in: delivery_method.expires_in do
  json.extract! delivery_method, :id, :method, :date_interval, :courier_delivery_dates
end
