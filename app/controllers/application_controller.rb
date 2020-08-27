class ApplicationController < ActionController::Base
  include SessionsHelper
  
  before_action :switch_locale

  private
  
  def switch_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def check_login
    return if logged_in?

    store_location
    flash[:danger] = t "users.show.login_remind"
    redirect_to login_path
  end
end
