class EvaluationsController < ApplicationController
  # HTML-контроллер для сохранения оценок через обычные формы (без JS).
  before_action :authenticate_user!

  def create
    image = Image.find(params[:image_id])
    evaluation = image.evaluations.find_or_initialize_by(user: current_user)
    evaluation.assign_attributes(evaluation_params)

    if evaluation.save
      redirect_back fallback_location: themes_path, notice: t("evaluations.saved")
    else
      redirect_back fallback_location: themes_path, alert: evaluation.errors.full_messages.to_sentence
    end
  end

  private

  def evaluation_params
    params.require(:evaluation).permit(:score, :comment)
  end
end
