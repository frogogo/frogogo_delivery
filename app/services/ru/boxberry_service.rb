class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'

  # Localities list:
  COURIER_LOCALITIES_LIST = 'courier_localities_list'
  PICKUP_LOCALITIES_LIST = 'pickup_localities_list'

  def initialize(locality)
    super

    @delivery_service = RU::BoxberryAdapter.new(locality)
    @provider = Provider.find_by(name: BOXBERRY_NAME)
  end

  def fetch_delivery_info
    return unless super

    return if city_code.blank?

    delivery_service.city_code = city_code
    @response = delivery_service.pickup_delivery_info

    save_data
  end

  def fetch_localities_list
    return unless super

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
      next if city['DeliveryPeriod'].blank?

      DeliveryMethod.create_or_find_by!(
        date_interval: city['DeliveryPeriod'].to_i,
        inactive: courier_delivery_method_inactive?,
        method: :courier,
        deliverable: locality,
        provider: provider
      )
      break
    end

    return if response.first['Address'].blank?

    @delivery_method = DeliveryMethod.create_or_find_by!(
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
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error(e.inspect)
    end
  end
end
