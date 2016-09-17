Rails.application.routes.draw do
  # get 'sessions/new'
  root  'sessions#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    get :show_admins
  end

  get     '/login',     to: 'sessions#new'
  post    '/login',     to: 'sessions#create'
  delete   '/logout',   to: 'sessions#destroy'

  get     '/login',     to: 'sessions#new'
  get     '/show_admins', to: 'users#show_admins'

end
