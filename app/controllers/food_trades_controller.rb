class FoodTradesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :veggies, :fruits, :dairy, :meats, :other]
  before_action :find_food_trade, only: [:destroy, :edit, :update]

  def index
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(status: "Available")

    @food_trades_geocoded = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).geocoded

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

    @markers =[{
        lat: @food_trade.latitude,
        lng: @food_trade.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { food_trade: @food_trade }),
        image_url: helpers.asset_url('icons/location.svg')
      }]
  end

  def new
    @food_trade = FoodTrade.new
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
    @user_address = current_user.address

    @user_input_ing = params[:ingredients]&.map {|id| Ingredient.find(id.to_i)}
  end

  def create

    multiple_food_trade_params.each do |param|
      new_user_own = UserOwnedIngredient.find_or_create_by(user_id: current_user.id, ingredient_id: param[:ingredient_id])
      @new_trade = FoodTrade.new(param.except(:ingredient_id))
      @new_trade.user_owned_ingredient = new_user_own
      @new_trade.save
    end


    # Still some limitations, cant validate the form... its a could-have

    # @food_trade = FoodTrade.new(food_trade_params)

    # if @food_trade.save!
      redirect_to food_trades_path
    # else
    #   render :new
    # end
  end

  def edit
    @user_owned_ingredient = @food_trade.user_owned_ingredient
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
  end
  
  def update
    @food_trade.update(food_trade_params)
    if @food_trade.save
      redirect_to :show
    else
      render :edit
    end
  end

  def destroy
    if @food_trade.destroy
      redirect_to :index
    else
      render :show
    end
  end
  
  # Current user's own food_trades
  def user_food_trades
    @user = current_user
    @food_trades = @user.food_trades.includes(user_owned_ingredient: [:user, :ingredient])
  end

  # FoodTrade categories start here
  def veggies
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(category: "Veggies")
  end

  def fruits
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(category: "Fruits")
  end

  def dairy
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(category: "Dairy")
  end

  def meats
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(category: "Meats")
  end

  def other
    @food_trades = FoodTrade.includes(user_owned_ingredient: [:user, :ingredient]).where(category: "Other")
  end

  private

  def find_food_trade
    @food_trade = FoodTrade.find(params[:id])
  end

  def multiple_food_trade_params
    params.require(:food_trade).map{|food_trade| food_trade.permit(:ingredient_id, :category, :description, :location, :photo)}
  end

  def food_trade_params
    params.require(:food_trade).permit(:description, :location, :category)
  end
end
