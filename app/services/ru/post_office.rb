class RU::PostOffice
  PICKUP_OFFICE_TYPES = %w[ГОПС СОПС]

  attr_reader :region
  attr_reader :settlement

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

  def temporary_closed?
    @is_temporary_closed == true
  end

  def pickup_available?
    @type_code.in?(PICKUP_OFFICE_TYPES)
  end
end
