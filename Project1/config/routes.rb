Rails.application.routes.draw do
  resources :bookings
  get 'show' => 'bookings#show'
  get 'search_room' =>'bookings#search_room'
  post 'search_room', to: 'bookings#search'
  get 'release_room' =>'bookings#release_room'
  post 'release_room', to: 'bookings#release'
  post 'index',to:'bookings#save_room'
  post'/cancel', to: 'bookings#cancel'

  # get 'sessions/new'
  root  'sessions#new'

  resources :rooms
  get 'view_room_history/:id', to: 'rooms#view_room_history', as: "view_room_history"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    get :show_admins
    get :add_admin
  end

  get     '/login',     to: 'sessions#new'
  post    '/login',     to: 'sessions#create'
  delete   '/logout',   to: 'sessions#destroy'

  get     '/login',     to: 'sessions#new'
  get     '/show_admins', to: 'users#show_admins'
  get   '/add_admin',    to: 'users#add_admin'
  # patch   '/add_admin',    to: 'users#add_admin'
  # post     '/add_admin',    to: 'users#add_admin'
  get   '/search_admin',    to: 'users#search_admin'
  patch   '/search_admin',    to: 'users#search_admin'
  post     '/search_admin',    to: 'users#search_admin'
  post     '/make_admin',        to: 'users#make_admin'
  post     '/remove_admin',        to: 'users#remove_admin'
  get      '/admin_manage_room',    to: 'users#admin_manage_room'
  get      '/admin_manage_user',    to: 'users#admin_manage_user'
  get       '/all_user',            to: 'users#all_user'
  post      '/remove_user',         to: 'users#remove_user'

  get       '/search_room',          to: 'bookings#search_room'
  get       '/user_manage_room',      to: 'users#user_manage_room'
  get       '/my_booking_history',            to: 'users#my_booking_history'

  post     '/room_availability_by_date',     to: 'bookings#room_availability_by_date'

  get       '/send_mail',               to: 'bookings#send_mail'
  post      '/dispatch_mail',           to: 'bookings#dispatch_mail'

  post       '/user_booking_history',            to: 'users#user_booking_history'
end
