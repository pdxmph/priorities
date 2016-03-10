Rails.application.routes.draw do

  devise_for :users
  get '/lists' => 'application#index'
  get '/goals' => 'application#index'
  get '/docs' => 'application#docs'
  match '/users/:id', :to => 'users#show', :as => :user,  :via => :get
  post 'goals/set_goal_priority' => 'goals#set_goal_priority'
  post 'goals/set_goal_frequency' => 'goals#set_goal_frequency'
  post 'goals/set_writer_coverage' => 'goals#set_writer_coverage'
  post 'goals/set_goal_support' => 'goals#set_goal_support'
  post 'goals/set_goal_work' => 'goals#set_goal_work'
  root 'application#index'
  resources :lists
  resources :goals

end
