Rails.application.routes.draw do
  resource :delivery_methods, only: %i[show], defaults: { format: :json }
end
