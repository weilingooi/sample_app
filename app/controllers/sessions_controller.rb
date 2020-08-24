class SessionsController < ApplicationController
  before_action :check_login, only: %i(new create)

  def new; end
    
  def create
    user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      if user.activated?
        params[:session][:remember].eql? Settings.remember_me ? remember(user) : forget(user)
        log_in user
        redirect_back_or user_path user
      else
        flash[:warning] = t ".mail.no_activated"
        redirect_to root_path
      end
    else
      flash.now[:danger] = t ".invalid_email_password_combination"
      render :new
    end
  end
    
  def destroy
    logout
    flash[:success] = t ".logout_success"
    redirect_to login_path
  end

  private

  def check_login
    return unless logged_in?
    redirect_to user_path id: current_user.id
  end
end
