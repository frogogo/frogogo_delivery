class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPostPickup'
  LETTER_TO_REPLACE = %w[ё е]
  SUBDIVISIONS_WITH_FIXED_INTERVALS = %w[Москва Московская]
  DEFAULT_DATE_INTERVAL = '2.00'

  def initialize(locality)
    super

    @delivery_service = RU::RussianPostAdapter.new(locality)
    @provider = Provider.find_by(name: RUSSIAN_POST_NAME)
  end

  def fetch_delivery_methods
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points(delivery_method)
    return unless super

    # Get unique points by address to avoid 'PG::UniqueViolation'
    @response = delivery_service.post_offices_list.uniq do |post_office|
      [post_office['address-source']]
    end

    unless SUBDIVISIONS_WITH_FIXED_INTERVALS.include?(locality.subdivision.name)
      @intervals = delivery_service.request_intervals(response.first['postal-code'])
    end

    delivery_points_attributes = response.map { |params| RU::PostOffice.new(params) }
      .select(&:valid?)
      .select { |post_office| post_office.settlement.downcase.in?(canonical_locality_names) }
      .select { |post_office| post_office.region.downcase.include?(canonical_subdivision_name) }
      .map { |post_office| post_office.to_attributes(date_interval, @provider.id) }

    return if delivery_points_attributes.blank?

    delivery_method.delivery_points
      .insert_all(delivery_points_attributes)
    delivery_method.update!(date_interval: date_interval)
  end

  def canonical_locality_names
    [
      locality.name,
      locality.data['city'],
      locality.data['settlement']
    ]
      .compact
      .map(&:downcase)
      .map { |name| name.gsub(*LETTER_TO_REPLACE) }
  end

  def canonical_subdivision_name
    locality.subdivision.name.downcase
  end

  def date_interval
    @date_interval ||= begin
      if @intervals.nil?
        # Russian Post always sends '1 day' for Moscow, we added +1 day
        '2'
      else
        "#{@intervals['delivery']['min']}-#{@intervals['delivery']['max']}"
      end
    end
  end
end
