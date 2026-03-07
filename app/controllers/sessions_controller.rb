class SessionsController < ApplicationController
  # Контроллер сессий: вход и выход пользователя.

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to themes_path, notice: t("auth.signed_in")
    else
      flash.now[:alert] = t("auth.invalid_credentials")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: t("auth.signed_out")
  end
end
