Rails.application.routes.draw do
  root 'homes#index'
  resources :homes

  get '/auth/:provider/callback', to: "auth_callbacks#create"
end
