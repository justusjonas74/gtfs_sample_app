Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/stops', to: 'stops#index'
  get '/stops_list', to: 'stops#stops_list', as: :stops_list
  get '/stops/:id', to: 'stops#show', as: :stop
  post '/stops', to: 'stops#find_stop', as: :find_stop
  root 'stops#search'


end
