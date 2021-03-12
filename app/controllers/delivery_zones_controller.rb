class DeliveryZonesController < ApplicationController
  before_action :set_locality

  def show
    return head :not_found if @locality.nil?

    @delivery_zone = @locality.delivery_zone

    return head :not_found if @delivery_zone.blank?
  end

  private

  def set_locality
    return nil if dadata_suggestion.nil?

    locality_uid = params[:locality_uid] || dadata_suggestion.kladr_id

    @locality = Locality.find_by(locality_uid: locality_uid)
    @locality = Locality.create!(dadata_suggestion.locality_attributes) if @locality.blank?
    @locality = @locality.parent_locality if @locality.parent_locality.present?
  end

  def dadata_suggestion
    dadata = DaDataService.instance

    @dadata_suggestion ||= if request_version >= 2
                             dadata.suggestion_from_locality_uid(params[:locality_uid])
                           else
                             dadata.suggestion_from_locality_and_subdivision(
                               params[:locality],
                               params[:subdivision]
                             )
                           end

    DaDataSuggestion.new(@dadata_suggestion) if @dadata_suggestion.present?
  end
end
