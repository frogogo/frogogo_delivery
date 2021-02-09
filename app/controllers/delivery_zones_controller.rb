class DeliveryZonesController < ApplicationController
  before_action :set_subdivision
  before_action :set_locality

  def show
    return head :not_found if @locality.nil?

    @delivery_zone = @locality.delivery_zone

    return head :not_found if @delivery_zone.blank?
  end

  private

  def set_locality
    @locality = @subdivision.localities.find_by(name: params[:locality])
    @locality = @subdivision.localities.create!(name: params[:locality]) if @locality.blank?
  end

  def set_subdivision
    @subdivision = Subdivision.find_or_create_by!(name: params[:subdivision])
  end
end
