class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  include SessionsHelper
  include UsersHelper

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      if check_owner? || check_admin?
        format.html{redirect_to admin_root_path, notice: exception.message}
      else
        format.html{redirect_to root_path, notice: exception.message}
      end
    end
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
