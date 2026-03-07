class User < ApplicationRecord
  # Модель пользователя системы экспертной оценки.
  # Пользователь может входить в систему и оставлять оценки для изображений по темам.

  has_many :evaluations, dependent: :destroy

  # Подключаем встроенную в Rails поддержку хеширования пароля.
  has_secure_password

  # Валидации полей пользователя.
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end
