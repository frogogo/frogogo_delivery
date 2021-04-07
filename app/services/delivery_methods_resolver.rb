class DeliveryMethodsResolver
  attr_reader :excluded_deliverable

  def initialize(locality)
    @locality = locality
  end

  def resolve
    return if @locality.delivery_zone.blank?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    @locality.needs_update? ? fetch_new_data : @locality.delivery_methods.active
  end

  private

  def fetch_new_data
    case I18n.locale
    when :ru
      RU::BoxberryService.new(@locality).fetch_delivery_methods
      RU::RussianPostService.new(@locality).fetch_delivery_methods
      RU::FivePostService.new(@locality).fetch_delivery_methods

      @locality.touch
      @locality.delivery_methods.active
    end
  end
end
