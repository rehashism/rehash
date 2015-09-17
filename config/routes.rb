Rails.application.routes.draw do
  root 'homes#index'

  get '/auth/:provider/callback', to: "auth_callbacks#create"
end
