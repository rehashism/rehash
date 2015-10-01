Rails.application.routes.draw do
  root 'homes#index'
  resources :homes
  resource :profile, only: :show

  get '/auth/:provider/callback', to: "auth_callbacks#create"
end
