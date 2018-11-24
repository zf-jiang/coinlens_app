class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		#login user and redirect to profile page
  		log_in user
  		redirect_to user
  	else
  		#display error and redirect back to login page
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
