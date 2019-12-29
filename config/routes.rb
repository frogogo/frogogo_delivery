Rails.application.routes.draw do
  defaults format: :json do
    resources :delivery_methods, only: %i[index] do
      resources :delivery_points, only: %i[index]
    end
  end
end
