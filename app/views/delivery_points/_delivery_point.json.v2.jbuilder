json.cache! delivery_point do
  json.extract! delivery_point,
                :address, :code, :date_interval, :directions,
                :estimate_delivery_date,
                :latitude, :longitude, :name, :phone_number, :uuid, :working_hours

  if delivery_point.provider.name == 'RussianPostPickup'
    json.working_hours format_working_hours(delivery_point)
  end

  # TODO: refactor
  if delivery_point.estimated_delivery_date.blank?
    json.estimated_delivery_date 10.days.from_now.to_date.to_s
  else
    json.estimated_delivery_date delivery_point.estimated_delivery_date
  end

  json.provider do
    json.partial! 'providers/provider', provider: delivery_point.provider
  end
end
