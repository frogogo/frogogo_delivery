json.cache! delivery_method do
  json.extract! delivery_method,
                :id, :date_interval, :inactive,
                :method, :time_intervals

  json.provider do
    json.partial! 'providers/provider', delivery_method.provider
  end
end
