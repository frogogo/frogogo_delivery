Rails.application.routes.draw do
  defaults format: :json do
    resources :delivery_methods, only: %i[index]
    resources :delivery_points, only: %i[index]
    resource :delivery_zone, only: %i[show]
  end
end
