class ThemesController < ApplicationController
  # Контроллер тем. Показывает список тем и страницу конкретной темы.

  before_action :authenticate_user!

  def index
    @themes = Theme.all.order(:title)
  end

  def show
    @theme = Theme.find(params[:id])
    @images = @theme.images.order(:id)
  end
end
