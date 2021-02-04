class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPostPickup'
  POST_OFFICE_TYPES = %w[ГОПС СОПС]
  LETTER_TO_REPLACE = %w[ё е]
  PERMANENT_INTERVALS_SUBDIVISIONS = %w[Москва Московская]
  DEFAULT_DATE_INTERVAL = '2.00'

  # TODO: remove delivery_method param
  def initialize(locality)
    super

    @delivery_service = RU::RussianPostAdapter.new(locality)
    @provider = Provider.find_by(name: RUSSIAN_POST_NAME)
  end

  def fetch_delivery_methods
    DeliveryMethod.create_or_find_by!(
      date_interval: DEFAULT_DATE_INTERVAL,
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points(deliver_method)
    return unless super

    @delivery_method = delivery_method

    # Get unique points by address to avoid 'PG::UniqueViolation'
    @response = delivery_service.post_offices_list.uniq do |post_office|
      [post_office['address-source']]
    end

    unless PERMANENT_INTERVALS_SUBDIVISIONS.include?(locality.subdivision.name)
      @intervals = delivery_service.request_intervals(response.first['postal-code'])
    end

    create_points
  end

  private

  def create_points
    delivery_points_attributes = response.map { |params| RU::PostOffice.new(params) }
      .select(&:valid?)
      .select { |post_office| post_office.settlement.downcase == canonical_locality_name }
      .select { |post_office| post_office.region.downcase.include?(canonical_subdivision_name) }
      .map { |post_office| post_office.to_attributes(date_interval, @provider.id) }

    @delivery_method.delivery_points.create(delivery_points_attributes)
    @delivery_method.update!(date_interval: date_interval)
  end

  def canonical_locality_name
    locality.name.downcase.gsub(*LETTER_TO_REPLACE)
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
