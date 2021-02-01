class DeliveryPointsResolver
  def initialize(delivery_methods_ids)
    @delivery_methods = DeliveryMethod.where(id: [delivery_methods_ids])
    @locality = @delivery_methods.first.locality
  end

  def resolve
    return if @delivery_methods.blank?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    result = @delivery_methods.map(&:delivery_points)

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
