class Evaluation < ApplicationRecord
  # Модель экспертной оценки изображения.

  belongs_to :user
  belongs_to :image

  # Оценка по шкале, например, от 1 до 5.
  validates :score, presence: true, inclusion: { in: 1..5 }
end
