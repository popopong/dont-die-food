class RemoveDataFromRecipeIngredients < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipe_ingredients, :data
  end
end
