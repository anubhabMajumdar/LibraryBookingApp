Rails.application.routes.draw do
  # get 'sessions/new'
  root  'sessions#new'
  resources :rooms
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
end
