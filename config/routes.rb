Rails.application.routes.draw do
  
  devise_for :users

  
  root 'application#index'
  get 'docs' => 'application#docs'
  get 'my_flags' => 'application#my_flags'
  #   get 'priorities' => 'areas#index'
  post 'comments/new' => 'comments#new'
  post 'areas/set_area_priority' => 'areas#set_area_priority'
  post 'areas/set_area_frequency' => 'areas#set_area_frequency'
  post 'areas/set_writer_coverage' => 'areas#set_writer_coverage'
  post 'areas/set_area_support' => 'areas#set_area_support'
  post 'areas/set_area_work' => 'areas#set_area_work'
  get '/users/' => 'users#index'
  get '/teams/services' => 'teams#services'
  get '/teams/scrum' => 'teams#scrum'
  match '/users/:id', :to => 'users#show', :as => :user,  :via => :get

  resources :teams do 
    resources :areas
  end

  
   
end
