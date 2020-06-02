class SavedRecipesController < ApplicationController
  def index
    user = current_user
    @saved_recipes = user.saved_recipes
  end

  def create
    @saved_recipe = SavedRecipe.new(saved_recipe_params)
    @saved_recipe.user = current_user
    @saved_recipe.save
    redirect_to recipe_path(params[:recipe_id])
    # if @saved_recipe.save
    #   # Good flash notice goes here
    #   redirect_to recipe_path
    # else
    #   # Bad flash notice goes here
    #   redirect_to recipe_path
    # end
  end

  def destroy
    @saved_recipe = SavedRecipe.find(params[:id])
    authorize @save_recipe
    @saved_recipe.destroy
    redirect_to recipe_path(params[:recipe_id])
    # redirect_to recipe_path(@saved_recipe.recipe)
    # redirect_to root_path

  end

  private

  def saved_recipe_params
    params.permit(:recipe_id)
  end
end
