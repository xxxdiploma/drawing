Drawing::Application.routes.draw do

  resources :users
  resources :articles
  resources :sessions, :only => [:new, :create, :destroy]

  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'

  match '/dropbox',  :to => 'dropbox#index'

  match 'dropbox/authorize', :controller => 'dropbox', :action => 'authorize'
  match 'dropbox/upload',    :controller => 'dropbox', :action => 'upload'


  root :to => 'pages#home'

end
