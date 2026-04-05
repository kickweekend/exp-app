module Api
  class EvaluationsController < ApplicationController
    # API-контроллер для сохранения оценок по изображению.
    before_action :authenticate_user!

    def create
      image = Image.find(params[:image_id])
      evaluation = image.evaluations.find_or_initialize_by(user: current_user)
      evaluation.assign_attributes(evaluation_params)

      if evaluation.save
        image.reload
        render json: {
          status: "ok",
          average_score: image.average_score,
          user_score: evaluation.score,
          user_comment: evaluation.comment.to_s,
          comments: image.comments_for_public_feed
        }
      else
        render json: { status: "error", errors: evaluation.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def evaluation_params
      params.require(:evaluation).permit(:score, :comment)
    end
  end
end

