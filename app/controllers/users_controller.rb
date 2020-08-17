class UsersController < ApplicationController
  before_action :load_user, only: :show
    
  def show; end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params
      
    if @user.save
      log_in @user
      flash[:success] = t ".welcome"
      redirect_to @user
    else
      flash.now[:danger] = t ".error"
      render :new
    end
  end
  
  private
  
  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
      
    flash[:danger] = t ".user.user_not_found "
    redirect_to root_path
   end
  
  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
