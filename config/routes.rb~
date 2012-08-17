Drawing::Application.routes.draw do
  get "users/new"

  match '/signup', :to => 'users#new'

  match '/contact', :to => 'pages#contact'

  root :to => 'pages#home'

end
