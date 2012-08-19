Drawing::Application.routes.draw do
  get "sessions/new"

  resources :users

  match '/signup', :to => 'users#new'
  match '/contact', :to => 'pages#contact'

  root :to => 'pages#home'

end
