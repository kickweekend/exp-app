class ImagesController < ApplicationController
  # Контроллер для отображения отдельного изображения (необязателен при использовании JS-навигации).

  before_action :authenticate_user!

  def show
    @image = Image.find(params[:id])
    @theme = @image.theme
  end
end
