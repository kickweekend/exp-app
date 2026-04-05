module Api
  class ImagesController < ApplicationController
    # API-контроллер для получения списка изображений по теме.
    before_action :authenticate_user!

    def index
      theme = Theme.find(params[:theme_id])
      images = theme.images.order(:created_at, :id)

      render json: {
        images: images.map { |image|
          mine = image.evaluations.find_by(user: current_user)
          {
            id: image.id,
            title: image.title,
            image_url: image.image_url,
            average_score: image.average_score,
            user_score: mine&.score,
            user_comment: mine&.comment.to_s,
            comments: image.comments_for_public_feed
          }
        }
      }
    end
  end
end

