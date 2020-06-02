class SavedRecipesController < ApplicationController
  def index
    user = current_user
    @saved_recipes = user.saved_recipes.includes([:recipe])
  end

  def create
    @saved_recipe = SavedRecipe.find(params[:id])
    @saved_recipe.user = current_user
    if @saved_recipe.save
      # Good flash notice goes here
      redirect_to :index
    else
      # Bad flash notice goes here
      redirect_to :index
    end
  end
end
