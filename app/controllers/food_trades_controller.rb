class FoodTradesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_food_trade, only: [:destroy, :edit, :update]

  def user_food_trades
    @user = current_user
    @food_trades = @user.food_trades
    authorize @food_trades
  end

  def index
    @food_trades = policy_scope(FoodTrade)
    @food_trades = FoodTrade.where(status: "Available")
    @food_trades_geocoded = FoodTrade.geocoded
    authorize @food_trades

    @markers = @food_trades_geocoded.map do |food_trade|
      {
        lat: food_trade.latitude,
        lng: food_trade.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { food_trade: food_trade }),
        image_url: helpers.asset_url('icons/location.svg')
      }
    end
  end

  def show
    @food_trade = FoodTrade.find(params[:id])
    authorize @food_trade
  end

  def new
    @food_trade = FoodTrade.new
    # An ingredient list for the users to select
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!

    authorize @food_trade
  end

  def create
    # An ingredient list for the users to select
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
    # find the ingredient
    ing = params[:food_trade][:user_owned_ingredient_id]
    ing_object = Ingredient.where(name: ing).first
    # create new user_owned_ingredient
    user_owned = UserOwnedIngredient.new
    user_owned.user = current_user
    user_owned.ingredient = ing_object
    user_owned.save

    @food_trade = FoodTrade.new(food_trade_params)
    @food_trade.user_owned_ingredient = user_owned
    authorize @food_trade

    if @food_trade.save
      flash.notice = "Thanks for sharing your #{ing}!"
      redirect_to food_trades_path
    else
      render :new
    end
  end

  def destroy
    authorize @food_trade
    if @food_trade.destroy
      redirect_to :index
    else
      render :show
    end
  end

  def edit
    authorize @food_trade
  end

  def update
    @food_trade.update(food_trade_params)
    authorize @food_trade
    if @food_trade.save
      redirect_to :show
    else
      render :edit
    end
  end

  private

  def find_food_trade
    @food_trade = FoodTrade.find(params[:id])
  end

  def food_trade_params
    params.require(:food_trade).permit(:description, :location, :category)
  end
end
