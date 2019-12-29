class ApplicationController < ActionController::API
  include ActionController::Caching

  before_action :authenticate

  private

  def authenticate
    # TODO: add authentication
    true
  end
end
