Rails.application.routes.draw do
  resources :visits
  #resources :questions
  #resources :formularies
  resources :items
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
   #config/routes.rb
   #post 'users#index/visit' , to: 'visit#create'
   
   #get 'users/index/visit', to: 'visit'

   post 'authenticate', to: 'authentication#authenticate'
   #get 'users', to: 'users#index'

end
