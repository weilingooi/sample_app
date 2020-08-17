class SessionsController < ApplicationController
  def new; end
    
  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      flash[:success] = t ".login_sucess"
      log_in user
      redirect_to user
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
end
