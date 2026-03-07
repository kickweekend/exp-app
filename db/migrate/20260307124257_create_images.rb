class CreateImages < ActiveRecord::Migration[8.1]
  def change
    create_table :images do |t|
      t.references :theme, null: false, foreign_key: true
      t.string :title
      t.string :image_url

      t.timestamps
    end
  end
end
