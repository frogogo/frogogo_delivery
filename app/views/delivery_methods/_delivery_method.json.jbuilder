json.cache! delivery_method, expires_in: delivery_method.expires_in do
  json.extract!(
    delivery_method,
    :id,
    :method,
    :courier_delivery_dates
  )

  # TODO: deprecate
  json.delivery_interval '2.00'
end
