class DeliveryPointsController < ApplicationController
  before_action :set_delivery_method

  def index
    @delivery_points = DeliveryPointsResolver.new(@delivery_method).resolve
    @delivery_points = if request_version < 3
                         @delivery_points.ordered.without_five_post
                       else
                         @delivery_points.ordered
                       end
  end

  private

  def set_delivery_method
    @delivery_method = DeliveryMethod.find(params[:delivery_method_id])
  end
end
