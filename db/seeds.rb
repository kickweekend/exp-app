# Начальные данные для приложения экспертиз (Experteese Lite).
# Файл можно безопасно запускать многократно: записи создаются или находят существующие.
# Запуск: bin/rails db:seed

puts "Создаём пользователя-демонстратора..."
demo_user = User.find_or_create_by!(email: "demo@example.com") do |user|
  user.name = "Demo Expert"
  user.password = "password"
  user.password_confirmation = "password"
end

puts "Создаём темы и изображения..."

themes_data = [
  {
    title: "Городские пейзажи",
    description: "Фотографии архитектуры и городской среды.",
    keyword: "city"
  },
  {
    title: "Природа и ландшафты",
    description: "Горы, леса, озёра и другие природные мотивы.",
    keyword: "nature"
  },
  {
    title: "Технологии и гаджеты",
    description: "Современные устройства, рабочие места и интерфейсы.",
    keyword: "technology"
  },
  {
    title: "Еда и напитки",
    description: "Кулинарные фотографии, блюда и ингредиенты.",
    keyword: "food"
  },
  {
    title: "Животные",
    description: "Домашние и дикие животные.",
    keyword: "animal"
  }
]

images_per_theme = 25 # 5 тем * 25 изображений = 125 изображений

themes_data.each_with_index do |theme_data, theme_index|
  theme = Theme.find_or_create_by!(title: theme_data[:title]) do |t|
    t.description = theme_data[:description]
  end

  puts "  Тема: #{theme.title}"

  images_per_theme.times do |i|
    # Используем бесплатный источник случайных изображений Unsplash.
    # Параметр sig делает URL детерминированным для конкретного изображения,
    # чтобы при повторных сеансах картинки не «прыгали».
    image_number = theme_index * images_per_theme + i + 1
    image_url = "https://source.unsplash.com/random/800x600?#{theme_data[:keyword]}&sig=#{image_number}"

    Image.find_or_create_by!(
      theme: theme,
      title: "#{theme.title} ##{image_number}",
      image_url: image_url
    )
  end
end

puts "Начальные данные успешно подготовлены."
