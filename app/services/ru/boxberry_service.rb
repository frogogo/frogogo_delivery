class RU::BoxberryService < DeliveryService
  BOXBERRY_NAME = 'Boxberry'
  SYMBOLS_TO_DELETE = '-'
  LETTER_TO_REPLACE = %w[ё е]
  EXCLUDED_DELIVERY_ZONE = 7
  DEFAULT_DATE_INTERVAL = '2.00'

  def initialize(locality)
    super

    @delivery_service = RU::BoxberryAdapter.new(locality)
    @provider = Provider.find_by(name: BOXBERRY_NAME)
    @subdivision_name = locality.subdivision.name
    @excluded_localities = I18n.t(
      @subdivision_name,
      scope: %i[excluded_deliverables boxberry pickup subdivisions], default: {}
    )[:localities]
    @courier_locality = delivery_service.courier_localities_list(locality.name)
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
    @pickup_delivery_method = DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality,
      date_interval: DEFAULT_DATE_INTERVAL
    )
  end

  def create_points
    @pickup_delivery_method.update(date_interval: response.first['DeliveryPeriod'])
    response.each do |pickup|
      @pickup_delivery_method.delivery_points.create!(
        address: format_string(pickup['Address']),
        code: pickup['Code'],
        date_interval: pickup['DeliveryPeriod'],
        directions: pickup['TripDescription']&.strip,
        latitude: pickup['GPS'].split(',').first,
        longitude: pickup['GPS'].split(',').last,
        name: format_string(pickup['AddressReduce']),
        phone_number: pickup['Phone'],
        provider: provider,
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
