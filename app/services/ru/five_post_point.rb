class RU::FivePostPoint
  WORDS_TO_REMOVE = %w[город область край республика автономный округ г]

  def initialize(params)
    @full_address = params['fullAddress']
    @latitude = params['address']['lat']
    @longitude = params['address']['lng']
    @postal_code = params['address']['zipCode']
    @region = params['address']['region']
    @city = params['address']['city']
    @working_hours = params['workHours']
    @date_interval = params['deliverySL']&.first
    @short_address = params['shortAddress']
  end

  def to_attributes(provider_id)
    {
      address: @full_address,
      code: @postal_code,
      created_at: Time.current,
      date_interval: date_interval,
      latitude: @latitude,
      longitude: @longitude,
      name: name,
      provider_id: provider_id,
      updated_at: Time.current,
      working_hours: working_hours
    }
  end

  def name
    "Постамат Пятёрочки #{@short_address}"
  end

  def working_hours
    "C #{@working_hours.first['opensAt']} до #{@working_hours.first['closesAt']}"
  end

  def canonical_region_name
    @region.split.delete_if { |word| WORDS_TO_REMOVE.include?(word.downcase) }.join(' ').downcase
  end

  def canonical_city_name
    @city.split.delete_if { |word| WORDS_TO_REMOVE.include?(word.downcase) }.join(' ').downcase
  end

  def date_interval
    return nil if @date_interval.blank?

    @date_interval['sl']
  end
end
