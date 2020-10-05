class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'
  SYMBOLS_TO_DELETE = '-'
  LETTER_TO_REPLACE = %w[ё е]

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
        name = city['Name'].downcase.gsub(*LETTER_TO_REPLACE)
        region = city['Region'].downcase

        next unless region == locality.subdivision.name.downcase
        next unless name == locality.name.downcase.gsub(*LETTER_TO_REPLACE)

        return format_string(city['Code'])
      end
  end

  def save_data
    localities_list[COURIER_LOCALITIES_LIST].each do |city|
      name = city['City'].downcase.gsub(*LETTER_TO_REPLACE)
      region = city['Area'].downcase

      next unless name == locality.name.downcase.gsub(*LETTER_TO_REPLACE) &&
                  region == locality.subdivision.name.downcase

      date_interval = city['DeliveryPeriod']
      if date_interval.blank?
        date_interval = I18n.t("#{locality.subdivision.name}.#{locality.name}",
                               scope: %i[custom_date_intervals boxberry],
                               default: nil).to_i
      end

      next if date_interval.blank?

      DeliveryMethod.create_or_find_by!(
        date_interval: date_interval,
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
        address: format_string(pickup['Address']),
        code: pickup['Code'],
        date_interval: pickup['DeliveryPeriod'],
        directions: pickup['TripDescription']&.strip,
        latitude: pickup['GPS'].split(',').first,
        longitude: pickup['GPS'].split(',').last,
        name: format_string(pickup['AddressReduce']),
        phone_number: pickup['Phone'],
        working_hours: pickup['WorkShedule']
      )
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error(e.inspect)
    end
  end

  def format_string(string)
    return if string.blank?

    string.delete_suffix(SYMBOLS_TO_DELETE).strip
  end
end
