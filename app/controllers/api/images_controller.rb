module Api
  class ImagesController < ApplicationController
    # API-контроллер для получения списка изображений по теме.
    before_action :authenticate_user!

    def index
      theme = Theme.find(params[:theme_id])
      images = theme.images.order(:id)

      render json: {
        images: images.as_json(only: %i[id title image_url])
      }
    end
  end
end

