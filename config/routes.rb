Rails.application.routes.draw do

  get 'users/new'
  #root 'welcome#index'
  root 'static_pages#home'

  #static pages
  get	'/about',		  to: 'static_pages#about'
  get	'/features',	to: 'static_pages#features'
  get	'/contact',		to: 'static_pages#contact'

  get	'/login',		  to: 'static_pages#login'

=begin
  adds RESTful actions for Users resource and
  provides named routes for generating Users.user URLs
  
  int i >= 1

  HTTP REQUEST    URL             ACTION      NAMED ROUTE           PURPOSE
  GET             /users          index       users_path            page to list all users
  GET             /users/:id      show        users_path(user)      page to show user
  GET             /users/new      new         new_user_path         page to register new user
  POST            /users          create      users_path            create a new user
  GET             /users/:id/edit edit        edit_users_path(user) page to edit user where user.id = i
  PATCH           /users/:id      update      user_path(user)       update user
  DELETE          /users/:id      destroy     user_path(user)       delete user
=end
  get '/register',  to: 'users#new'
  post'/register',  to: 'users#create'
  resources :users, :path => "u"
  #get '/u/profile', to: 'users#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end