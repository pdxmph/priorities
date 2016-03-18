Rails.application.routes.draw do

  devise_for :users
  
  get '/lists' => 'application#index'
  get '/lists/admin' => 'lists#admin'
  get '/goals' => 'application#index'
  get '/docs' => 'application#docs'
  get '/users/' => 'users#index'
  match '/users/:id', :to => 'users#show', :as => :user,  :via => :get
  post 'goals/set_goal_priority' => 'goals#set_goal_priority'
  post 'goals/set_goal_effort' => 'goals#set_goal_effort'
  post 'goals/set_goal_support' => 'goals#set_goal_support'
  post 'goals/set_goal_work' => 'goals#set_goal_work'
  root 'application#index'
  resources :lists
  resources :goals do
    post :update_row_order, on: :collection
  end
  resources :users, only: [:show, :edit, :update]

end
