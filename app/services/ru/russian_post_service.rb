class RU::RussianPostService < DeliveryService
  RUSSIAN_POST_NAME = 'RussianPostPickup'
  POST_OFFICE_TYPES = %w[ГОПС СОПС]
  LETTER_TO_REPLACE = %w[ё е]
  PERMANENT_INTERVALS_SUBDIVISIONS = %w[Москва Московская]
  DEFAULT_DATE_INTERVAL = '2.00'

  def initialize(locality, delivery_method: nil)
    super

    @delivery_service = RU::RussianPostAdapter.new(locality)
    @provider = Provider.find_by(name: RUSSIAN_POST_NAME)
    @delivery_method = delivery_method
  end

  def fetch_delivery_methods
    DeliveryMethod.create_or_find_by!(
      date_interval: DEFAULT_DATE_INTERVAL,
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points
    return unless super

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
    response.each { |post_office_object| RU::PostOffice.new(post_office_object) }
      .reject(&:temporary_closed?)
      .reject { |post_office| post_office.settlement.nil? }
      .select { |post_office| post_office.settlement == canonical_locality_name }
      .select { |post_office| post_office.region == canonical_subdivision_name }
      .select(&:pickup_available?)

    response.each do |post_office|
      next if post_office['is-temporary-closed'] == true
      settlement = post_office['settlement']

      next if settlement.nil?

      settlement = settlement.downcase.gsub(*LETTER_TO_REPLACE)
      region = post_office['region'].downcase

      next unless settlement == locality.name.downcase.gsub(*LETTER_TO_REPLACE) &&
                  region.include?(locality.subdivision.name.downcase)
      next unless post_office['type-code'].in?(POST_OFFICE_TYPES)

      @delivery_method.delivery_points.create!(
        address: "#{post_office['address-source']}, #{post_office['settlement']}",
        code: post_office['postal-code'],
        date_interval: date_interval,
        latitude: post_office['latitude'],
        longitude: post_office['longitude'],
        name: "Почта России №#{post_office['postal-code']}",
        provider: provider,
        working_hours: post_office['working-hours']
      )
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error(e.inspect)
    end

    @delivery_method.update!(date_interval: date_interval)
  end

  def canonical_locality_name
    locality.name.downcase.gsub(*LETTER_TO_REPLACE)
  end

  def canonical_subdivision_name
    locality.subdivision.name.downcase
  end

  def date_interval
    if @intervals.nil?
      # Russian Post always sends '1 day' for Moscow, we added +1 day
      '2'
    else
      "#{@intervals['delivery']['min']}-#{@intervals['delivery']['max']}"
    end
  end
end
