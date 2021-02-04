class DeliveryPointsResolver
  def initialize(delivery_method)
    @delivery_method = delivery_method
    @locality = @delivery_method.deliverable
  end

  def resolve
    return if @delivery_method.blank?
    return if @delivery_method.courier?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    fetch_new_data if @delivery_method.delivery_points.empty?
    @delivery_method.delivery_points
  end

  private

  def fetch_new_data
    case I18n.locale
    when :ru
      RU::BoxberryService.new(@locality, delivery_method: @delivery_method).fetch_pickup_points
      RU::RussianPostService.new(@locality).fetch_pickup_points(@delivery_method)

      @locality.touch
      @locality.delivery_methods.active
    end
  end
end
