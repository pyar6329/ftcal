class ApplicationController < ActionController::Base
  before_filter :set_locale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_locale
    I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def after_sign_in_path_for(resource)
    calendar_index_path
  end

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, alert: t("devise.failure.unauthenticated")
    end
  end
end
