class RU::ShoplogisticsService < DeliveryService
  SHOPLOGISTICS_NAME = 'ShopLogistics'

  CITIES_WITH_EXTENDED_TIME_INTERVALS = ['Москва, Санкт-Петербург']
  EXTENDED_TIME_INTERVALS = ['9:00–12:00', '12:00–15:00', '15:00–18:00', '18:00-21:00']
  TIME_INTERVALS = ['9:00–12:00', '12:00–15:00', '15:00–18:00']

  def initialize(locality)
    super

    @delivery_service = RU::ShoplogisticsAdapter.new(locality)
    @provider = Provider.find_by(name: SHOPLOGISTICS_NAME)
  end

  def fetch_delivery_info
    return unless super

    @response = delivery_service.delivery_info['answer']
    return if response.blank?
    return unless response['error'] == '0'

    save_data
  end

  private

  def save_data
    response['tarifs']['tarif'].each do |tarif|
      case tarif['tarifs_type']
      when '1'
        next unless tarif['is_basic'] == '1'

        courier_delivery_method(tarif['srok_dostavki'])
      when '2'
        # May potentialy crash
        begin
          pickup_delivery_method(tarif['srok_dostavki'])

          @pickup_delivery_method.delivery_points.create!(
            address: tarif['address'],
            date_interval: tarif['srok_dostavki'],
            directions: tarif['proezd_info']&.strip,
            latitude: tarif['latitude'],
            longitude: tarif['longitude'],
            name: tarif['address'],
            phone_number: tarif['phone'],
            working_hours: tarif['worktime']
          )
        rescue ActiveRecord::RecordNotUnique => e
          Rails.logger.error(e.inspect)
        end
      end
    end
  end

  def courier_delivery_method(date_interval)
    @courier_delivery_method ||=
      DeliveryMethod.create!(
        date_interval: date_interval,
        method: :courier,
        time_intervals: time_intervals,
        deliverable: locality,
        provider: provider
      )
  end

  def pickup_delivery_method(date_interval)
    @pickup_delivery_method ||=
      DeliveryMethod.create!(
        date_interval: date_interval,
        method: :pickup,
        time_intervals: time_intervals,
        deliverable: locality,
        provider: provider
      )
  end

  def time_intervals
    CITIES_WITH_EXTENDED_TIME_INTERVALS.include?(locality.name) ? EXTENDED_TIME_INTERVALS : TIME_INTERVALS
  end
end
