class FixThemeDescriptions < ActiveRecord::Migration[7.1]
  def up
    say_with_time "Updating theme descriptions" do
      update_theme("Городские пейзажи", "фото дорог и небоскребов")
      update_theme("Природа и ландшафты", "Умиротворяющее зрелище.")
      update_theme("Технологии", "Различные устройства и технологии")
      update_theme("Животные", "Различные красивые дикие животные")
    end
  end

  def down
    say_with_time "Rollback theme descriptions" do
      update_theme("Городские пейзажи", "Фотографии архитектуры и городской среды.")
      update_theme("Природа и ландшафты", "Горы, леса, озёра и другие природные мотивы.")
      update_theme("Технологии", "Современные устройства, рабочие места и интерфейсы.")
      update_theme("Животные", "Домашние и дикие животные.")
    end
  end

  private

  def update_theme(title, description)
    Theme.where(title: title).update_all(description: description)
  end
end
