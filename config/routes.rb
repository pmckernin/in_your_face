Rails.application.routes.draw do
 
get '/auth/:provider/callback', to: 'sessions#create'
root to: 'pages#index'
delete '/logout', to: 'sessions#destroy'

get '/get_user_data', to: 'sessions#get_user_data'
end
