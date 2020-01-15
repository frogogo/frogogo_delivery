class DeliveryMethodsFilter
  RU_SUBDIVISION_LIST = ['Москва', 'Санкт-Петербург', 'Московская', 'Ленинградская']

  def initialize(delivery_methods)
    @delivery_methods = delivery_methods
  end

  def filter
    return delivery_methods unless I18n.locale == :ru

    deliverable = delivery_methods.first.deliverable
    subdivision = deliverable.class == Locality ? deliverable.subdivision : subdivision

    if RU_SUBDIVISION_LIST.include?(subdivision.name)
      # Only ShopLogistics for courier
      delivery_methods.joins(:provider).where.not(method: :courier).where.not(providers: { name: 'Boxberry' })
    elsif delivery_methods.joins(:provider).where.not(method: :courier).where.not(providers: { name: 'Boxberry' }).any?
      # Only Boxberry courier in case if subdivision is not on the list and Boxberry method exist
      delivery_methods.joins(:provider).where.not(method: :courier).where.not(providers: { name: 'ShopLogistics' })
    else
      delivery_methods
    end
  end

  private_methods

  attr_reader :delivery_methods
end
