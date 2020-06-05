class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @recipes = Recipe.all
    @food_trade = FoodTrade.new

    if user_signed_in?
      @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:ingredient, :user]).where(status: "Available").select do |food_trade|
        food_trade.user_owned_ingredient.user != current_user
      end
    else
      @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:ingredient, :user]).where(status: "Available").shuffle
    end
  end

  private

  def set_title
    @title = "Don't Die Food - Save food together!"
  end
end
