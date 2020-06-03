class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :search]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    @save_recipe = SavedRecipe.new
    @user_saved_recipe = SavedRecipe.where(user: current_user, recipe: @recipe)

    if user_signed_in?
      @user_owned_ingredients_name = current_user.ingredients.pluck(:name)
    else
      @user_owned_ingredients_name = []
    end
  end

  def search
    if params[:ingredients]
      @search_terms_count = 0
      current_user.pantry_items.each do |item|
        if !(params[:ingredients].include?(item.ingredient_id.to_s))
          @search_terms_count+=1
        end
      end

      @results = Recipe.all.to_a.map do |recipe|
        next unless params[:ingredients].all? { |id| recipe.ingredient_ids.map { |id| id.to_s }.include?(id.to_s) }
        { recipe_object: recipe, matched_ings: current_user.number_of_pantry_items_for(recipe) }
      end

      raise
      @results = @results.compact
    end

  end
end
