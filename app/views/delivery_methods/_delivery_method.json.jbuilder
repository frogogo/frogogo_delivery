json.cache! delivery_method, expires_in: delivery_method.expires_in do
  json.extract! delivery_method,
                :courier_delivery_dates,
                :estimate_delivery_date,
                :date_interval, :method, :time_intervals

  if delivery_method.estimated_delivery_date.blank?
    json.estimated_delivery_date 10.days.from_now.to_date.to_s
  else
    json.estimated_delivery_date delivery_method.estimated_delivery_date
  end

  json.provider do
    provider = delivery_method.delivery_points&.first&.provider
    # Courier method has no points, so we pass boxberry
    json.partial! 'providers/provider', provider: provider || 'boxberry'
  end
end
