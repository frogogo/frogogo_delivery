class DeliveryMethodsResolver
  attr_reader :excluded_deliverable

  def initialize(locality)
    @locality = locality
  end

  def resolve
    return if @locality.delivery_zone.blank?
    return if @locality.delivery_zone.inactive? || @locality.subdivision.delivery_zone.inactive?

    delivery_methods = @locality.delivery_methods

    # TODO: refactor
    if delivery_methods.any? && delivery_methods.last.updated_at > 1.week.ago
      @locality.delivery_methods
    else
      fetch_new_data
    end
  end

  private

  def fetch_new_data
    case I18n.locale
    when :ru
      RU::BoxberryService.new(@locality).fetch_delivery_methods
      RU::RussianPostService.new(@locality).fetch_delivery_method

      @locality.delivery_methods.active
    end
  end
end
