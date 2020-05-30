class FoodTradesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_food_trade, only: [:destroy, :edit, :update]

  def user_food_trades
    @user = current_user
    @food_trades = @user.food_trades
  end

  def index
    @food_trades = FoodTrade.where(status: "Available")

    @food_trades_geocoded = FoodTrade.geocoded

    @markers = @food_trades_geocoded.map do |food_trade|
      {
        lat: food_trade.latitude,
        lng: food_trade.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { food_trade: food_trade }),
        image_url: helpers.asset_url('/images/icons/pin.svg')
      }
    end
  end

  def show
    @food_trade = FoodTrade.find(params[:format])
  end

  def new
    @food_trade = FoodTrade.new
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
  end

  def create
    # find the ingredient and its id
    ing = params[:food_trade][:user_owned_ingredient_id]
    ing_id = Ingredient.where(name: ing).first.id
    # create new user_owned_ingredient
    new_user_own = UserOwnedIngredient.create(user_id: current_user.id, ingredient_id: ing_id)

    @food_trade = FoodTrade.new(food_trade_params)
    @food_trade.user_owned_ingredient = new_user_own

    if @food_trade.save
      redirect_to :index
    else
      render :new
    end
  end

  def destroy
    if @food_trade.destroy
      redirect_to :index
    else
      render :show
    end
  end

  def edit
  end

  def update
    @food_trade.update(food_trade_params)
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
