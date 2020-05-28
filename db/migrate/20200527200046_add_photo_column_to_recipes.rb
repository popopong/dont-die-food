class AddPhotoColumnToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :photo, :string
  end
end
