class DeliveryPointsResolver
  def initialize(delivery_method)
    @delivery_method = delivery_method
    @locality = @delivery_method.locality
  end

  def resolve
    return if @delivery_method.blank?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    result = @delivery_method.delivery_points

    return result if result.present?

    fetch_new_data
  end

  private

  def fetch_new_data
    case I18n.locale
    when :ru
      RU::BoxberryService.new(@locality).fetch_pickup_points
      RU::RussianPostService.new(@locality).fetch_pickup_points

      locality.delivery_methods.active
    end
  end
end
