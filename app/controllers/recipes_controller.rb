class RecipesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @recipes = policy_scope(Recipe)
    @recipes = Recipe.all
    skip_authorization
  end

  def show
    @recipe = Recipe.find(params[:id])
    skip_authorization
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
