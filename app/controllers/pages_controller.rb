class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @recipes = Recipe.all
    @food_trade = FoodTrade.new
  end
end
