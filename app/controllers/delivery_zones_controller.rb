class DeliveryZonesController < ApplicationController
  def show
    @delivery_zone = Locality
      .joins(:subdivision)
      .find_by(name: search_params[:locality], subdivisions: { name: search_params[:subdivision] })
      &.delivery_zone

    head :not_found if @delivery_zone.blank?
  end

  private

  def search_params
    params.permit(:locality, :subdivision)
  end
end
