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

    # Get unique points by address to avoid 'PG::UniqueViolation'
    @response = delivery_service.post_offices_list.uniq do |post_office|
      [post_office['address-source']]
    end

    save_data
  end

  private

  def save_data
    response.each do |post_office|
      next unless post_office['settlement'] == locality.name &&
                  post_office['region'].include?(locality.subdivision.name)
      next unless post_office['type-code'].in?(POST_OFFICE_TYPES)
      next if post_office['is-temporary-closed'] == true

      date_interval = I18n.t('custom_date_intervals.russian_post.intervals')
      pickup_delivery_method(date_interval)

      @pickup_delivery_method.delivery_points.create!(
        address: "#{post_office['address-source']}, #{post_office['settlement']}",
        code: post_office['postal-code'],
        date_interval: date_interval,
        latitude: post_office['latitude'],
        longitude: post_office['longitude'],
        phone_number: '8 800 200-58-88',
        name: "#{post_office['address-source']}, #{post_office['postal-code']}",
        working_hours: post_office['working-hours']
      )
    end
  end

  def pickup_delivery_method(date_interval)
    @pickup_delivery_method ||=
      DeliveryMethod.create_or_find_by!(
        date_interval: date_interval,
        method: :pickup,
        deliverable: locality,
        provider: provider
      )
  end
end
