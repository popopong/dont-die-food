class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @save_recipe = SavedRecipe.new
    @user_saved_recipe = SavedRecipe.where(user: current_user, recipe: @recipe)
  end

  def search
    if params[:ingredients]
      @results = Recipe.all.to_a.select do |recipe|
        params[:ingredients].all? { |id| recipe.ingredient_ids.map { |id| id.to_s }
                            .include?(id) }
      end
    end
  end
end
