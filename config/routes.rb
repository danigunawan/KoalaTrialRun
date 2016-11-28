Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'auth/:provider/callback', to: 'home#create', via: [:get, :post]
  match 'signout', to: 'home#destroy', as: 'signout', via: [:get, :post]
  get '/posts/:page_id' => 'projects#posts', as: 'posts'
  get '/update_post' => 'projects#update_post', as: 'update_post'
  get '/permissions' => 'projects#permissions', as: 'permissions'
  get '/pages' => 'projects#pages', as: 'pages'
  get '/clear_session' => 'home#clear_session', as: 'clear_session'
  get '/facebook/callback' => 'home#callback_facebook', as: 'callback_facebook'
  root to: 'home#index'
end
