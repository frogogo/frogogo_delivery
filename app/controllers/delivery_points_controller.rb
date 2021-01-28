class DeliveryPointsController < ApplicationController
  def index
    @delivery_points = DeliveryPointsResolver.new(search_params).resolve

    @delivery_points = @delivery_points
      .joins(:delivery_method)
      .active
      .order(provider_id: :asc, date_interval: :asc)
      .uniq { |delivery_point| [delivery_point.latitude, delivery_point.longitude] }
  end

  private

  def search_params
    params.permit(delivery_methods_ids: [])
  end
end
