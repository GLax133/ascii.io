class SessionsController < ApplicationController

  def new
	@user = User.new
  end

  def create
    @user =
      User.find_by_email(@auth["email"])

    unless @user.persisted?
      render 'users/new', :status => 422
    else
      self.current_user = @user
      redirect_back_or_to root_url, :notice => "Logged in!"
    end
  end

  def auth
	user = User.authenticate(params[:user][:email], params[:user][:password])
  	if user
      		self.current_user = user
    		redirect_to root_url, :notice => "Logged in!"
  	else
    		flash.now.alert = "Invalid email or password"
    		redirect_to "/login"
  	end
  end

  def destroy
    self.current_user = nil
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

  def failure
    redirect_to root_url, :alert => params[:message]
  end




end
