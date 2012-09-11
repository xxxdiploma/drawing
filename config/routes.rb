Drawing::Application.routes.draw do

  resources :users
  resources :articles
  resources :sessions, :only => [:new, :create, :destroy]

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'

  match '/storage',  :to => 'storage#index'

  match '/storage/authorize', :controller => 'storage', :action => 'authorize'
  match '/storage/upload',    :controller => 'storage', :action => 'upload'


  root :to => 'pages#home'

end
