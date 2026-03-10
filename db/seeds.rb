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
    folder: "city"
  },
  {
    title: "Природа и ландшафты",
    description: "Горы, леса, озёра и другие природные мотивы.",
    folder: "nature"
  },
  {
    title: "Технологии и гаджеты",
    description: "Современные устройства, рабочие места и интерфейсы.",
    folder: "technology"
  },
  {
    title: "Еда и напитки",
    description: "Кулинарные фотографии, блюда и ингредиенты.",
    folder: "food"
  },
  {
    title: "Животные",
    description: "Домашние и дикие животные.",
    folder: "animal"
  }
]

themes_data.each do |theme_data|
  theme = Theme.find_or_create_by!(title: theme_data[:title]) do |t|
    t.description = theme_data[:description]
  end

  puts "  Тема: #{theme.title}"

  folder_name = theme_data[:folder]
  folder_path = Rails.root.join("public", "images", folder_name)

  unless Dir.exist?(folder_path)
    puts "    Папка #{folder_path} не найдена, пропускаем."
    next
  end

  files = Dir.glob(folder_path.join("*.{jpg,jpeg,png,gif,webp}")).sort_by do |path|
    # Сортировка по дате создания файла (если недоступно, по дате изменения).
    begin
      File.birthtime(path)
    rescue StandardError
      File.mtime(path)
    end
  end

  urls = files.map { |path| "/images/#{folder_name}/#{File.basename(path)}" }

  # Удаляем изображения темы, для которых больше нет файлов в папке.
  theme.images.where.not(image_url: urls).destroy_all

  files.each_with_index do |path, index|
    image_url = "/images/#{folder_name}/#{File.basename(path)}"
    image = theme.images.find_or_initialize_by(image_url: image_url)
    image.title = "#{theme.title} ##{index + 1}"

    file_time =
      begin
        File.birthtime(path)
      rescue StandardError
        File.mtime(path)
      end

    image.created_at = file_time
    image.updated_at = file_time
    image.save!
  end
end

puts "Начальные данные успешно подготовлены."
