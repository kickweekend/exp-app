class UsersController < ApplicationController
  # Профиль пользователя: список всех оценённых им изображений.
  before_action :authenticate_user!

  def show
    @evaluations = current_user.evaluations.includes(image: :theme).order(created_at: :desc)
  end
end

