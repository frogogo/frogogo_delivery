class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'
  SYMBOLS_TO_DELETE = '-'
  LETTER_TO_REPLACE = %w[ё е]
  EXCLUDED_DELIVERY_ZONE = 7
  DEFAULT_DATE_INTERVAL = '2.00'

  def initialize(locality, delivery_method: nil)
    super

    @delivery_service = RU::BoxberryAdapter.new(locality)
    @provider = Provider.find_by(name: BOXBERRY_NAME)
    @subdivision_name = locality.subdivision.name
    @excluded_localities = I18n.t(
      @subdivision_name,
      scope: %i[excluded_deliverables boxberry pickup subdivisions], default: {}
    )[:localities]
    @courier_locality = delivery_service.courier_localities_list(locality.name)
    @delivery_method = delivery_method
  end

  def fetch_delivery_methods
    return if delivery_service.city_code.blank?
    return if locality.delivery_zone.zone.to_i == EXCLUDED_DELIVERY_ZONE
    return if @excluded_localities&.include?(locality.name)

    create_pickup_delivery_method

    return if @courier_locality.blank?

    create_courier_delivery_method
  end

  def fetch_pickup_points
    return if DeliveryMethod.where(deliverable: locality, method: :pickup).blank?

    @response = delivery_service.pickup_delivery_info

    return if @response.first['Address'].blank?

    create_points
  end

  private

  def create_courier_delivery_method
    date_interval = @courier_locality.dig(0, 'DeliveryPeriod') ||
                    I18n.t("#{@subdivision_name}.#{locality.name}",
                           scope: %i[custom_date_intervals boxberry],
                           default: nil).to_i

    DeliveryMethod.create_or_find_by!(
      inactive: courier_delivery_method_inactive?,
      method: :courier,
      deliverable: locality,
      date_interval: date_interval
    )
  end

  def create_pickup_delivery_method
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality,
      date_interval: DEFAULT_DATE_INTERVAL
    )
  end

  def create_points
    @delivery_method.update!(date_interval: response.first['DeliveryPeriod'])

    delivery_points_attributes = response.map { |params| boxberry_point_attributes(params) }
    @delivery_method.delivery_points.insert_all(delivery_points_attributes)
  end

  def boxberry_point_attributes(boxberry_point)
    {
      address: format_string(boxberry_point['Address']),
      code: boxberry_point['Code'],
      created_at: Time.current,
      date_interval: boxberry_point['DeliveryPeriod'],
      directions: boxberry_point['TripDescription']&.strip,
      latitude: boxberry_point['GPS'].split(',').first,
      longitude: boxberry_point['GPS'].split(',').last,
      name: format_string(boxberry_point['AddressReduce']),
      phone_number: boxberry_point['Phone'],
      provider_id: provider.id,
      updated_at: Time.current,
      working_hours: boxberry_point['WorkShedule']
    }
  end

  def format_string(string)
    return if string.blank?

    string.delete_suffix(SYMBOLS_TO_DELETE).strip
  end
end
