class SavedRecipesController < ApplicationController
  def index
    @title = "My cookbook - Don't Die Food"
    @saved_recipes = policy_scope(SavedRecipe)
    user = current_user
    @saved_recipes = user.saved_recipes.includes([:recipe])

    authorize @saved_recipes
  end

  def create
    @saved_recipe = SavedRecipe.new(saved_recipe_params)
    @saved_recipe.user = current_user
    authorize @saved_recipe
    @saved_recipe.save
    redirect_to recipe_path(params[:recipe_id])
  end

  def destroy
    @saved_recipe = SavedRecipe.find(params[:id])
    authorize @saved_recipe
    @saved_recipe.destroy
    redirect_to recipe_path(params[:recipe_id])
  end

  def toggle
    if params[:toggle_action] == "create"
      @saved_recipe = SavedRecipe.new(recipe_id: params[:recipe_id])
      @saved_recipe.user = current_user

      authorize @saved_recipe
      
      @saved_recipe.save
      redirect_to recipe_path(params[:recipe_id])
    else
      @saved_recipe = SavedRecipe.find(params[:saved_recipe_id])

      authorize @saved_recipe

      @saved_recipe.destroy
      redirect_to recipe_path(params[:recipe_id])
    end
  end

  private

  def saved_recipe_params
    params.permit(:recipe_id, :saved_recipe_id, :toggle_action)
  end
end
