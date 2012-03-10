require "stripe"
class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def require_user
    redirect_to root_path unless current_user
  end

  def admin_required
    return redirect_to root_path unless current_user && current_user.is_admin?
  end

  def current_camp
    @camp = Stripe::Plan.retrieve(params[:id])
  end

end
