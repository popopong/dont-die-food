class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    recipes_array = ["Cauliflower & potato curry", "Gluten-Free Chocolate Cake Donuts", "Nutella Stuffed Pumpkin Doughnut Holes", "Easy Tuscan Bean Soup",  "Chicken Spinoccoli – Breaded Stuffed Chicken Breast With Spinach, Broccoli and Cheese", "Vegan Wild-Rice-Stuffed Butternut Squash", "Bison Burger", "Kale, Strawberry & Avocado Salad with Lemon Poppy Seed Dressing", "Brussel Sprout Salad",  "Buffalo Beer Cheese Fries"]
    @recipes = recipes_array.map do |recipe_name|
      Recipe.find_by(title: recipe_name)
    end
    # @recipes = Recipe.all
    @food_trade = FoodTrade.new

    if user_signed_in?
      @food_trades = FoodTrade.includes({photo_attachment: :blob}, user_owned_ingredient: [:ingredient, :user]).where(status: "Available").select do |food_trade|
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
