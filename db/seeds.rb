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
    # Используем ЛОКАЛЬНЫЕ файлы изображений из каталога public/images.
    # Чтобы не хранить сотни разных файлов, мы переиспользуем ограниченный
    # набор названий, например:
    #   /images/city-1.jpg, /images/city-2.jpg, ... /images/city-5.jpg
    #   /images/nature-1.jpg, ... и т.д.
    #
    # Вам достаточно положить по 5 файлов на тему в public/images,
    # с указанными именами. В базе при этом будет 25 записей на тему.
    image_number = theme_index * images_per_theme + i + 1
    physical_index = (i % 5) + 1
    image_url = "/images/#{theme_data[:keyword]}-#{physical_index}.webp"

    image = Image.find_or_initialize_by(
      theme: theme,
      title: "#{theme.title} ##{image_number}"
    )
    image.image_url = image_url
    image.save!
  end
end

puts "Начальные данные успешно подготовлены."
