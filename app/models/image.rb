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
end
