class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPost'
  POST_OFFICE_TYPES = %w[ГОПС СОПС]

  def initialize(locality)
    super

    @delivery_service = RU::RussianPostAdapter.new(locality)
    @provider = Provider.find_by(name: RUSSIAN_POST_NAME)
  end

  def fetch_delivery_info
    return unless super
    # Temporarily create delivery_points for Moscow only
    # return unless locality.delivery_zone_id == 1

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

      next unless response['settlement'] == locality.name &&
                  response['region'].downcase.include?(locality.subdivision.name.downcase)
      next unless response['type-code'].in?(POST_OFFICE_TYPES)
      next if response['is-temporary-closed'] == true

      date_interval = if @intervals.blank?
                        # Russian Post always sends '1 day' for Moscow
                        '1 день'
                      else
                        "От #{@intervals['delivery']['min']} до #{@intervals['delivery']['max']} дней"
                      end

      delivery_method(date_interval)

      @delivery_method.delivery_points.create!(
        address: "#{response['address-source']}, #{response['settlement']}",
        code: response['postal-code'],
        date_interval: date_interval,
        latitude: response['latitude'],
        longitude: response['longitude'],
        name: "#{response['address-source']}, #{response['postal-code']}",
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
