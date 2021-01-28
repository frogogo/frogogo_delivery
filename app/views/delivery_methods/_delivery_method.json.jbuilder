json.cache! delivery_method, expires_in: delivery_method.expires_in do
  json.extract! delivery_method, :estimate_delivery_date, :date_interval, :method

  json.provider do
    json.partial! 'providers/provider', provider: delivery_method.provider
  end
end
