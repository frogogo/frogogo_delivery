class DeliveryPointsController < ApplicationController
  def index
    @delivery_points = DeliveryMethod.find(params[:delivery_method_id]).delivery_points

    return head :not_found if @delivery_points.blank?
  end
end
