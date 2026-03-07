class Theme < ApplicationRecord
  # Модель темы, к которой относятся изображения для экспертной оценки.

  has_many :images, dependent: :destroy

  validates :title, presence: true
end
