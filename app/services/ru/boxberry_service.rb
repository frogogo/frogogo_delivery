class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'
  TIME_INTERVALS = '10:00–18:00'
  # TODO: SET 10:00–22:00 for Moscow and SPB

  def initialize(locality)
    super

    @delivery_service = RU::BoxberryAdapter.new(locality)
    @provider = Provider.find_by(name: BOXBERRY_NAME)
  end

  def fetch_delivery_info
    @response = delivery_service.localities_list
    return if city_code.blank?

    delivery_service.city_code = city_code
    @response = delivery_service.pickup_delivery_info
    save_data
  end

  private

  attr_reader :provider

  def city_code
    @city_code =
      response.parsed_response.each do |city|
        if city['Name'] == locality.name && city['Region'] == locality.subdivision.name
          return city['Code']
        end
      end
  end

  def save_data
    return if response.parsed_response.first['Address'].blank?

    @delivery_method = DeliveryMethod.create!(
      date_interval: response.parsed_response.first['DeliveryPeriod'],
      method: :pickup, deliverable: locality, provider: provider
    )

    DeliveryMethod.create!(
      date_interval: response.parsed_response.first['DeliveryPeriod'],
      method: :courier, time_intervals: [TIME_INTERVALS],
      deliverable: locality, provider: provider
    )

    response.parsed_response.each do |pickup|
      DeliveryPoint.create!(
        address: pickup['Address'],
        directions: pickup['TripDescription'],
        latitude: pickup['GPS'].split(',').first,
        longitude: pickup['GPS'].split(',').last,
        name: pickup['Name'],
        phone_number: pickup['Phone'],
        working_hours: pickup['WorkShedule'],
        delivery_method: @delivery_method
      )
    end
  end
end
