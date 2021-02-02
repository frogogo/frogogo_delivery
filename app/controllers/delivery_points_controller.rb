class DeliveryPointsController < ApplicationController
  def index
    @delivery_points = DeliveryPointsResolver.new(@delivery_method).resolve

    @delivery_points = @delivery_points
      .joins(:delivery_method)
      .active
      .order(provider_id: :asc, date_interval: :asc)
      .uniq { |delivery_point| [delivery_point.latitude, delivery_point.longitude] }
  end

  private

  def set_delivery_method
    @delivery_method = DeliveryMethod.find(params[:id])
  end
end
