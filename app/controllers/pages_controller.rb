class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @recipes = Recipe.all
    @food_trade = FoodTrade.new
  end

  private

  def set_title
    @title = "Don't Die Food - Save food together!"
  end
end
