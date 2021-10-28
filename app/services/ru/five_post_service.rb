class RU::FivePostService
  def initialize
    @api = RU::FivePostAPI.new
  end

  def fetch_delivery_methods(locality)
    DeliveryMethod.create_or_find_by!(
      method: :pickup,
      deliverable: locality
    )
  end

  def fetch_pickup_points
    delivery_points_attributes = @api
      .pickup_points
      .map(&:to_attributes)

    DeliveryPoint.upsert_all(delivery_points_attributes)
  end
end
