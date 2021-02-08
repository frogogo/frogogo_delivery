json.cache! delivery_method do
  json.extract!(
    delivery_method,
    :id,
    :method,
    :courier_delivery_dates
  )

  # TODO: deprecate
  json.delivery_interval '2.00'
end
