class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
  
    @micropost = current_user.microposts.build
    @feeds = current_user.microposts.by_created_at.page(params[:page]).per Settings.per_page
  end

  def help; end
end
