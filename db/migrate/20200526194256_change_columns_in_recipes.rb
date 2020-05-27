class ChangeColumnsInRecipes < ActiveRecord::Migration[6.0]
  def change
    remove_column :recipes, :data
    add_column :recipes, :ingredients_data, :json
    add_column :recipes, :steps_data, :json
  end
end
