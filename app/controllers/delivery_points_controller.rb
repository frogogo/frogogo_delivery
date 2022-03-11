class DeliveryPointsController < ApplicationController
  before_action :set_delivery_method, only: %i[index]
  before_action :set_delivery_point, only: %i[show]

  def index
    @delivery_points = DeliveryPointsResolver.new(@delivery_method).resolve

    if request_version < 3
      @delivery_points = @delivery_points.ordered.without_five_post
    else
      # TODO: Рязань
      if @delivery_method.deliverable.locality_uid == '6200000100000'
        @delivery_points = @delivery_points.ordered
      else
        @delivery_points = @delivery_points.ordered.without_five_post
      end
    end
  end

  def show
  end

  private

  def set_delivery_point
    @delivery_point = DeliveryPoint.find(params[:id])
  end

  def set_delivery_method
    @delivery_method = DeliveryMethod.find(params[:delivery_method_id])
  end
end
