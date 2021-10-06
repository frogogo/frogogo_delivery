class RU::PostOffice
  LETTER_TO_REPLACE = %w[ё е]
  PICKUP_OFFICE_TYPES = %w[ГОПС СОПС]

  def initialize(params)
    @address_source = params['address-source']
    @is_temporary_closed = params['is-temporary-closed']
    @latitude = params['latitude']
    @longitude = params['longitude']
    @postal_code = params['postal-code']
    @region = params['region']
    @settlement = params['settlement']
    @type_code = params['type-code']
    @working_hours = params['working-hours']
  end

  def valid?
    !temporary_closed? && @settlement.present? && pickup_available?
  end

  def canonical_settlement
    @settlement.downcase.gsub(*LETTER_TO_REPLACE)
  end

  def canonical_region
    @region.downcase.gsub(*LETTER_TO_REPLACE)
  end

  def to_attributes(date_interval, provider_id)
    {
      address: address,
      code: @postal_code,
      created_at: Time.current,
      date_interval: date_interval,
      latitude: @latitude,
      longitude: @longitude,
      name: name,
      payment_methods: %w[cash card],
      provider_id: provider_id,
      updated_at: Time.current,
      working_hours: @working_hours.to_s
    }
  end

  private

  def temporary_closed?
    @is_temporary_closed == true
  end

  def pickup_available?
    @type_code.in?(PICKUP_OFFICE_TYPES)
  end

  def address
    "#{@address_source}, #{@settlement}"
  end

  def name
    "Почта России №#{@postal_code}"
  end
end
