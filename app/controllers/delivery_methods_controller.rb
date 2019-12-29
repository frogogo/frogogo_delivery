class DeliveryMethodsController < ApplicationController
  def show
    @delivery_methods = DeliveryMethod.search(search_params)

    return head :no_content if @delivery_methods.blank?
  end

  private

  def search_params
    params.permit(:locale, :locality, :subdivision)
  end
end
