class UsersController < ApplicationController
  # Профиль пользователя: список всех оценённых им изображений.
  before_action :authenticate_user!

  def show
    @evaluations = current_user.evaluations.includes(image: :theme).order(created_at: :desc)
    @image_statistics = build_image_statistics

    respond_to do |format|
      format.html
      format.csv { send_data statistics_csv, filename: "image_statistics_#{Date.current}.csv" }
    end
  end

  private

  # Сводная статистика по всем изображениям:
  # средняя оценка и количество оценок.
  def build_image_statistics
    Image
      .left_joins(:evaluations)
      .select(
        "images.id, images.title, images.image_url, "\
        "COALESCE(AVG(evaluations.score), 0) AS average_score, "\
        "COUNT(evaluations.id) AS evaluations_count"
      )
      .group("images.id")
      .order("images.created_at ASC, images.id ASC")
  end

  def statistics_csv
    rows = []
    rows << [
      I18n.t("statistics.image"),
      I18n.t("statistics.average_score"),
      I18n.t("statistics.evaluations_count")
    ]

    @image_statistics.each do |stat|
      rows << [
        stat.title,
        stat.average_score.to_f.round(2),
        stat.evaluations_count.to_i
      ]
    end

    rows.map { |row| row.map { |cell| csv_escape(cell) }.join(",") }.join("\n")
  end

  def csv_escape(value)
    escaped = value.to_s.gsub('"', '""')
    %("#{escaped}")
  end
end

