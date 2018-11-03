Rails.application.routes.draw do

  get 'users/new'
  #root 'welcome#index'
  root 'static_pages#home'

  #static pages
  get	'/about',		  to: 'static_pages#about'
  get	'/features',	to: 'static_pages#features'
  get	'/contact',		to: 'static_pages#contact'

  #register and login
  get '/register',  to: 'users#new'
  get	'/login',		  to: 'static_pages#login' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
