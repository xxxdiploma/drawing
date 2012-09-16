Drawing::Application.routes.draw do

  resources :users
  resources :articles
  resources :sessions, :only => [:new, :create, :destroy]

  resources :storages do
    collection do
      get :authorize
      post :upload
    end
  end

  match 'signup'  => 'users#new'
  match 'signin'  => 'sessions#new'
  match 'signout' => 'sessions#destroy'

  match 'contact' => 'pages#contact'
  match 'about'   => 'pages#about'

  root :to => 'pages#home'

end
