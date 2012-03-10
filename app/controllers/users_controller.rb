class UsersController < ApplicationController
  before_filter :require_user, :only => [:edit, :update]

  def new
    redirect_to root_path, :notice => "You are already registered" if current_user
    session[:camp_id] = params[:camp_id]
    @camp = Camp.find(params[:camp_id])
    @user = User.new
    @billing_info = @user.build_billing_info
  end

  def create
    @camp = Camp.find(session[:camp_id])
    @user = User.new(params[:user])
    @user.stripe_camp_id = session[:camp_id]
    @user.camp_id = session[:camp_id]
    if @user.save
      session[:camp_id] = nil
      redirect_to root_path, :notice => "Signed up!"
    else
      render :action => :new
    end
  rescue Stripe::StripeError => e
    logger.error e.message
    @user.errors.add :base, "There was a problem with your credit card"
    @user.stripe_token = nil
    render :action => :new
  end

  def edit
   @user = current_user
  end

  def update
    current_user.update_attributes(params[:user])
    if current_user.save
      redirect_to root_path, :notice => "Profile updated"
    else
      render :action => :edit
    end
  rescue Stripe::StripeError => e
    logger.error e.message
    @user.errors.add :base, "There was a problem with your credit card"
    @user.stripe_token = nil
    render :action => :edit
  end
end
