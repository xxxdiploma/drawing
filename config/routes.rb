Drawing::Application.routes.draw do

  resources :users
  resources :articles
  resources :storages
  resources :sessions, :only => [:new, :create, :destroy]

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'

  match '/storages/authorize', :controller => 'storages', :action => 'authorize'
  match '/storages/upload',    :controller => 'storages', :action => 'upload'

  root :to => 'pages#home'

end
