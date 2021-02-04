class DeliveryPointsController < ApplicationController
  before_action :set_delivery_method

  def index
    @delivery_points = DeliveryPointsResolver.new(@delivery_method).resolve
    return head :not_found if @delivery_points.blank?

    @delivery_points = @delivery_points
      .includes(:provider)
      .order(provider_id: :asc, date_interval: :asc)
  end

  private

  def set_delivery_method
    @delivery_method = DeliveryMethod.find(params[:delivery_method_id])
  end
end
