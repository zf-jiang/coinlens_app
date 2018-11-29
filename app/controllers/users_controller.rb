require 'uri'
#require 'httparty'
require 'json'

class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
=begin 
	equivalent to:
	@user = User.new(name: "Foo Bar", email: "foo@bar.com",
					 password: "foobar", password_confirmation: "foobar")
=end
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to CoinLens!"
  		redirect_to @user 	#successful registration redirects user to profile
  	else
  		render 'new'
  	end
  end

  def show
  	@user = User.find(params[:id])	#find method converts string 'id' into type int
  end

  #used to limit attributes submitted in params[:user] to only include table attributes
private
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
