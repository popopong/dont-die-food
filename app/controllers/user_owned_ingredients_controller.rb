class UserOwnedIngredientsController < ApplicationController
  def create
    @user_owned_ingredient = UserOwnedIngredient.new(params[:id]) # Params[:id] may need to change
    @user_owned_ingredient.user = current_user
    authorize @user_owned_ingredient
    if @saved_recipe.save
      # Good flash notice goes here
      redirect_to "recipes/show"
    else
      # Bad flash notice goes here
      redirect_to "recipes/show"
    end
  end

  def destroy
    @user_owned_ingredient = UserOwnedIngredient.find(params[:id])
    @user_owned_ingredient.user = current_user
    authorize @user_owned_ingredient
    if @saved_recipe.destroy
      # Good flash notice goes here
      redirect_to "recipes/show"
    else
      # Bad flash notice goes here
      redirect_to "recipes/show"
    end
  end
end
