class SessionsController < ApplicationController
  before_action :log_in, only: %i(new create)

  def new; end
    
  def create
    user = User.find_by email: params[:session][:email].downcase
    if @user&.authenticate params[:session][:password]
      flash[:success] = t ".login_sucess"
      params[:session][:remember] == Settings.remember_me ? remember(@user) : forget(@user)
      log_in @user
      redirect_back_or user_path @user
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

  def log_in
    return unless logged_in?
    redirect_to user_path id: current_user.id
  end
end
