class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPost'

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
      next if post_office['is-temporary-closed'] == true || post_office['type-code'] == 'ПОЧТОМАТ'

      date_interval = I18n.t('custom_date_intervals.russian_post.intervals')
      pickup_delivery_method(date_interval)

      @pickup_delivery_method.delivery_points.create!(
        address: "#{post_office['address-source']}, #{post_office['settlement']}",
        date_interval: date_interval,
        latitude: post_office['latitude'],
        longitude: post_office['longitude'],
        name: post_office['address-source'],
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
