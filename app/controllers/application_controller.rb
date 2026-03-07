class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Базовый контроллер приложения.
  # Содержит общую для всех контроллеров логику: выбор локали и текущего пользователя.

  before_action :set_locale

  helper_method :current_user, :user_signed_in?

  private

  # Определение текущего пользователя по session.
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    current_user.present?
  end

  # Принудительное требование аутентификации.
  def authenticate_user!
    redirect_to new_session_path, alert: t("auth.please_sign_in") unless user_signed_in?
  end

  # Установка локали из параметров или по умолчанию.
  def set_locale
    I18n.locale = params[:locale].presence_in(I18n.available_locales.map(&:to_s)) || I18n.default_locale
  end

  # Добавляем параметр locale ко всем сгенерированным URL.
  def default_url_options
    { locale: I18n.locale }
  end
end
