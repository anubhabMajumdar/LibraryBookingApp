Rails.application.routes.draw do
  resources :bookings
  get 'search_room' =>'bookings#search_room'
  post 'search_room', to: 'bookings#search'
  get 'release_room' =>'bookings#release_room'
  post 'release_room', to: 'bookings#release'
  post 'index',to:'bookings#save_room'
  post'/cancel', to: 'bookings#cancel'

  resources :rooms

  root"bookings#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
