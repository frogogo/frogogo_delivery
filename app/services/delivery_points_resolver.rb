class DeliveryPointsResolver
  def initialize(delivery_method)
    @delivery_method = delivery_method
    @locality = @delivery_method.deliverable
  end

  def resolve
    return if @delivery_method.blank?
    return if @delivery_method.courier?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    if @delivery_method.needs_update?
      fetch_new_data
    else
      @delivery_method.delivery_points.active
    end
  end

  private

  def fetch_new_data
    case I18n.locale
    when :ru
      RU::BoxberryService.new(@locality).fetch_pickup_points(@delivery_method)
      RU::RussianPostService.new(@locality).fetch_pickup_points(@delivery_method)

      @delivery_method.touch
      @delivery_method.delivery_points.active
    end
  end
end
