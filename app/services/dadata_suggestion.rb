class DaDataSuggestion
  def initialize(data)
    @data = data
  end

  def kladr_id
    @data['kladr_id']
  end

  def region
    @data['region']
  end

  def locality_attributes
    {
      name: @data['city'],
      latitude: @data['geo_lat'],
      locality_uid: kladr_id,
      longitude: @data['geo_lon'],
      data: @data
    }
  end
end
