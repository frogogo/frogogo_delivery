class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    # TODO: add authentication
    true
  end
end
