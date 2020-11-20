class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPostPickup'
  POST_OFFICE_TYPES = %w[ГОПС СОПС]
  LETTER_TO_REPLACE = %w[ё е]

  def initialize(locality)
    super

    @delivery_service = RU::RussianPostAdapter.new(locality)
    @provider = Provider.find_by(name: RUSSIAN_POST_NAME)
  end

  def fetch_delivery_info
    return unless super

    @response = delivery_service.post_offices_list.uniq
    @intervals = delivery_service.request_intervals(response.first) unless locality.name == 'Москва'

    save_data
  end

  private

  def save_data
    response.each do |post_office|
      request = delivery_service.request_post_offices(post_office)

      next unless request.success?

      response = request.parsed_response

      settlement = response['settlement'].downcase.gsub(*LETTER_TO_REPLACE)
      region = response['region'].downcase

      next unless settlement == locality.name.downcase.gsub(*LETTER_TO_REPLACE) &&
                  region.include?(locality.subdivision.name.downcase)
      next unless response['type-code'].in?(POST_OFFICE_TYPES)
      next if response['is-temporary-closed'] == true

      date_interval = if @intervals.blank?
                        # Russian Post always sends '1 day' for Moscow
                        '1'
                      else
                        "#{@intervals['delivery']['min']}-#{@intervals['delivery']['max']}"
                      end

      delivery_method(date_interval)

      @delivery_method.delivery_points.create!(
        address: "#{response['address-source']}, #{response['settlement']}",
        code: response['postal-code'],
        date_interval: date_interval,
        latitude: response['latitude'],
        longitude: response['longitude'],
        name: "Почта России №#{response['postal-code']}",
        working_hours: response['working-hours']
      )
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error(e.inspect)
    end
  end

  def delivery_method(date_interval)
    @delivery_method ||=
      DeliveryMethod.create_or_find_by!(
        date_interval: date_interval,
        method: :pickup,
        deliverable: locality,
        provider: provider
      )
  end
end
