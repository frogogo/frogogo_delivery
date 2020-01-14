class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'

  CITIES_WITH_EXTENDED_TIME_INTERVALS = ['Москва, Санкт-Петербург']
  EXTENDED_TIME_INTERVALS = ['10:00–14:00', '14:00–18:00', '18:00-22:00']
  TIME_INTERVALS = ['10:00–14:00', '14:00–18:00']

  # Localities list:
  COURIER_LOCALITIES_LIST = 'courier_localities_list'
  PICKUP_LOCALITIES_LIST = 'pickup_localities_list'

  def initialize(locality)
    super

    @delivery_service = RU::BoxberryAdapter.new(locality)
    @provider = Provider.find_by(name: BOXBERRY_NAME)
  end

  def fetch_delivery_info
    super

    return if city_code.blank?

    delivery_service.city_code = city_code
    @response = delivery_service.pickup_delivery_info

    save_data
  end

  def fetch_localities_list
    super

    localities_list = {}
    localities_list[COURIER_LOCALITIES_LIST] = delivery_service.courier_localities_list
    localities_list[PICKUP_LOCALITIES_LIST] = delivery_service.pickup_localities_list

    localities_list
  end

  private

  def city_code
    @city_code ||=
      localities_list[PICKUP_LOCALITIES_LIST].each do |city|
        if city['Name'] == locality.name && city['Region'] == locality.subdivision.name
          return city['Code']
        end
      end
  end

  def save_data
    localities_list[COURIER_LOCALITIES_LIST].each do |city|
      next unless city['City'] == locality.name && city['Area'] == locality.subdivision.name
      next unless city['DeliveryPeriod'].present?

      DeliveryMethod.create!(
        date_interval: city['DeliveryPeriod'].to_i,
        method: :courier,
        time_intervals: time_intervals,
        deliverable: locality,
        provider: provider
      )
      break
    end

    return if response.first['Address'].blank?

    @delivery_method = DeliveryMethod.create!(
      date_interval: response.first['DeliveryPeriod'],
      method: :pickup, deliverable: locality, provider: provider
    )

    response.each do |pickup|
      @delivery_method.delivery_points.create!(
        address: pickup['Address'],
        date_interval: pickup['DeliveryPeriod'],
        directions: pickup['TripDescription'].strip,
        latitude: pickup['GPS'].split(',').first,
        longitude: pickup['GPS'].split(',').last,
        name: pickup['AddressReduce'],
        phone_number: pickup['Phone'],
        working_hours: pickup['WorkShedule']
      )
    end
  end

  def time_intervals
    CITIES_WITH_EXTENDED_TIME_INTERVALS.includes?(locality.name) ? EXTENDED_TIME_INTERVALS : TIME_INTERVALS
  end
end
