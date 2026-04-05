class Image < ApplicationRecord
  # Модель изображения, которое оценивают эксперты.

  belongs_to :theme
  has_many :evaluations, dependent: :destroy

  validates :title, presence: true
  validates :image_url, presence: true

  # Средняя оценка по всем пользователям (может быть nil, если оценок ещё нет).
  def average_score
    evaluations.average(:score)&.to_f
  end

  # Комментарии пользователей для боковой панели и API (только непустой текст).
  def comments_for_public_feed(limit: 80)
    evaluations
      .includes(:user)
      .order(created_at: :desc)
      .limit(limit)
      .filter_map do |evaluation|
        next if evaluation.comment.blank?

        {
          user_name: evaluation.user.name,
          comment: evaluation.comment.to_s.strip,
          score: evaluation.score
        }
      end
  end
end
