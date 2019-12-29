class DeliveryMethodsController < ApplicationController
  def show
    @delivery_methods = DeliveryMethod.search(search_params)

    return head :not_found if @delivery_methods.blank?
  end

  private

  def search_params
    params.permit(:locale, :locality, :subdivision)
  end
end
