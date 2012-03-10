class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if user.is_admin?
        session[:user_id] = user.id
        redirect_to root_path, :notice => "Welcome back"
      else
        redirect_to root_path
      end
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, :notice => "Signed out"
  end
end
