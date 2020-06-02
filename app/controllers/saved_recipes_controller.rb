class SavedRecipesController < ApplicationController
  def index
    @saved_recipes = policy_scope(SavedRecipe)
    user = current_user
    @saved_recipes = user.saved_recipes
    authorize @saved_recipes
  end

  def create
    @saved_recipe = SavedRecipe.find(params[:id])
    @saved_recipe.user = current_user
    authorize @saved_recipe
    if @saved_recipe.save
      # Good flash notice goes here
      redirect_to :index
    else
      # Bad flash notice goes here
      redirect_to :index
    end
  end
end
