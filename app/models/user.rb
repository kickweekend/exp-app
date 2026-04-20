require "digest/md5"

class User < ApplicationRecord
  # Модель пользователя системы экспертной оценки.
  # Пользователь может входить в систему и оставлять оценки для изображений по темам.

  has_many :evaluations, dependent: :destroy

  # Подключаем встроенную в Rails поддержку хеширования пароля.
  has_secure_password

  # Валидации полей пользователя.
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  # URL аватара Gravatar. Если у пользователя нет аватара в сервисе,
  # будет показан автоматически сгенерированный identicon.
  def gravatar_url(size: 80)
    email_hash = Digest::MD5.hexdigest(email.to_s.strip.downcase)
    "https://www.gravatar.com/avatar/#{email_hash}?s=#{size}&d=identicon&r=g"
  end
end
