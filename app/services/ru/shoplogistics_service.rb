class RU::ShopLogisticsService < DeliveryService
  SHOPLOGISTICS_NAME = 'ShopLogistics'
  SYMBOLS_TO_DELETE = ','

  def initialize(locality)
    super

    @delivery_service = RU::ShopLogisticsAdapter.new(locality)
    @provider = Provider.find_by(name: SHOPLOGISTICS_NAME)
  end

  def fetch_delivery_info
    return unless super

    @response = delivery_service.delivery_info['answer']

    return if response.blank?
    return if response['error'] != '0'
    return if response['tarifs'].blank?

    @response = response['tarifs']['tarif']
    @response = [response] if response.is_a?(Hash)

    save_data
  end

  private

  def save_data
    response.each do |tarif|
      next unless tarif['is_basic'] == '1'

      case tarif['tarifs_type']
      when '1'
        next unless tarif['partner'].nil?

        courier_delivery_method(tarif['srok_dostavki'])
      when '2'
        next unless tarif['pickup_places_type_name'] == 'А' # cyrillic symbol

        begin
          pickup_delivery_method(tarif['srok_dostavki'])

          @pickup_delivery_method.delivery_points.create!(
            address: format_string(tarif['address']),
            code: tarif['pickup_place_code'],
            date_interval: tarif['srok_dostavki'],
            directions: format_string(tarif['proezd_info']),
            latitude: tarif['latitude'],
            longitude: tarif['longitude'],
            name: format_string(tarif['address']),
            phone_number: tarif['phone'],
            working_hours: tarif['worktime']
          )
        rescue ActiveRecord::RecordNotUnique => e
          Rails.logger.error(e.inspect)
        end
      end
    end
  end

  def courier_delivery_method(date_interval)
    @courier_delivery_method ||=
      DeliveryMethod.create_or_find_by!(
        date_interval: date_interval,
        inactive: courier_delivery_method_inactive?,
        method: :courier,
        deliverable: locality,
        provider: provider
      )
  end

  def pickup_delivery_method(date_interval)
    @pickup_delivery_method ||=
      DeliveryMethod.create_or_find_by!(
        date_interval: date_interval,
        method: :pickup,
        deliverable: locality,
        provider: provider
      )
  end

  def format_string(string)
    return if string.blank?

    string.delete_prefix(SYMBOLS_TO_DELETE).delete_suffix(SYMBOLS_TO_DELETE).strip
  end
end
