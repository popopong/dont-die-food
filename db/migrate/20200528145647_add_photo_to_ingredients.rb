class AddPhotoToIngredients < ActiveRecord::Migration[6.0]
  def change
    add_column :ingredients, :photo, :string
  end
end
