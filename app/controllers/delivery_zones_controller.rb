class DeliveryZonesController < ApplicationController
  before_action :set_locality

  def show
    return head :not_found if @locality.nil?

    @delivery_zone = @locality.delivery_zone

    return head :not_found if @delivery_zone.blank?
  end

  private

  def set_locality
    locality_uid = params[:locality_uid] || dadata_suggestion.kladr_id

    @locality = Locality.find_by(locality_uid: locality_uid)
    @locality = Locality.create!(dadata_suggestion.locality_attributes) if @locality.blank?
    @locality = @locality.parent_locality if @locality.parent_locality.present?
  end

  def dadata_suggestion
    dadata = DaDataService.instance

    if params[:locality_uid].present?
      dadata.suggestion_from_locality_uid(params[:locality_uid])
    else
      dadata.suggestion_from_locality_and_subdivision(
        params[:locality],
        params[:subdivision]
      )
    end
  end
end
