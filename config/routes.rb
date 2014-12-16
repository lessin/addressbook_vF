Rails.application.routes.draw do

  ### ACCESS + MAIN ROUTES

  root 'access#login'
  get '/', to: 'access#login'
  get 'index', to: 'access#login'
  post 'signup', to: 'access#create', as: 'create_user'
  get 'signup', to: 'access#new'
  get 'login', to: 'access#login', as: 'login'
  post 'login', to: 'access#attempt_login'
  get 'logout', to: 'access#logout'
  get 'home', to: 'claims#index'


  get 'get_subjects', to: 'claims#return_subjects'
  get 'get_verbs', to: 'claims#return_verbs'

  resources :claims

end
