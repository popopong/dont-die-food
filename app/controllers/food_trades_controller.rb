class FoodTradesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :veggies, :fruits, :dairy, :meats, :other]
  before_action :find_food_trade, only: [:destroy, :edit, :update]

  def index
    @title = "Community - Don't Die Food"
    @food_trades = policy_scope(FoodTrade).includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).where(status: "Available").order(created_at: :desc)

    @food_trades_geocoded = @food_trades.geocoded
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
    @title = "Details of #{@food_trade.user_owned_ingredient.ingredient.name} - Don't Die Food"
    @markers =[{
        lat: @food_trade.latitude,
        lng: @food_trade.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { food_trade: @food_trade }),
        image_url: helpers.asset_url('icons/location.svg')
      }]

    authorize @food_trade
  end

  def new
    @title = "Sharing food - Don't Die Food"
    @food_trade = FoodTrade.new
    authorize @food_trade
    # An ingredient list for the users to select
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
    @user_address = current_user.address

    @user_input_ing = params[:ingredients]&.map {|id| Ingredient.find(id.to_i)}
  end

  def create
    # Single ingredient food_trade
    if params[:food_trade].class == ActionController::Parameters
      food_trade = params[:food_trade]
      @new_trade = FoodTrade.new(food_trade_params)
      ingredient = Ingredient.find_by(name: params["food_trade"]["user_owned_ingredient_id"])
      new_user_own = UserOwnedIngredient.find_or_create_by(user_id: current_user.id, ingredient_id: ingredient.id)
      @new_trade.user_owned_ingredient = new_user_own

      authorize @new_trade

      if @new_trade.save
      else
        flash.notice = "An error occured, please try again later"
        render :new
      end
    else
      # Multiple ingredients food_trades
      multiple_food_trade_params.each do |param|
        new_user_own = UserOwnedIngredient.find_or_create_by(user_id: current_user.id, ingredient_id: param[:ingredient_id])
        @new_trade = FoodTrade.new(param.except(:ingredient_id))
        @new_trade.user_owned_ingredient = new_user_own

        authorize @new_trade
        if @new_trade.save
        else
          flash.notice = "An error occured, please try again later"
          render :new
        end
      end
    end
  end

  def edit
    authorize @food_trade
    @user_owned_ingredient = @food_trade.user_owned_ingredient
    @title = "Edit #{@user_owned_ingredient.ingredient.name} - Don't Die Food"
    @ingredients = Ingredient.all
    @ingredients_name = @ingredients.map { |ing| ing.name }
    @ingredients_name.sort!
  end

  def update
    authorize @food_trade
    @food_trade.update(food_trade_params)
    if @food_trade.save
      redirect_to food_trade_path(@food_trade)
    else
      render :edit
    end
  end

  def destroy
    authorize @food_trade
    if @food_trade.destroy
      flash.notice = "Giveaway successfully deleted!"
      redirect_to private_user_food_trades_path(current_user)
    else
      render :show
    end
  end

  # Current user's own food_trades
  def user_food_trades
    @title = "My giveaways - Don't Die Food"
    @user = current_user
    @food_trades = @user.food_trades.includes(user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc)
    authorize @food_trades
  end

  # FoodTrade categories start here
  def veggies
    @title = "Veggie giveaways - Don't Die Food"
    @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc).where(category: "Veggies")
    authorize @food_trades
  end

  def fruits
    @title = "Fruit giveaways - Don't Die Food"
    @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc).where(category: "Fruits")
    authorize @food_trades
  end

  def dairy
    @title = "Dairy giveaways - Don't Die Food"
    @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc).where(category: "Dairy")
    authorize @food_trades
  end

  def meats
    @title = "Meat giveaways - Don't Die Food"
    @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc).where(category: "Meats")
    authorize @food_trades
  end

  def other
    @title = "Other giveaways - Don't Die Food"
    @food_trades = FoodTrade.includes(:photo_attachment, user_owned_ingredient: [:user, :ingredient]).order(created_at: :desc).where(category: "Other")
    authorize @food_trades
  end

  private

  def find_food_trade
    @food_trade = FoodTrade.find(params[:id])
  end

  def multiple_food_trade_params
    params.require(:food_trade).map{|food_trade| food_trade.permit(:ingredient_id, :category, :description, :location, :photo)}
  end

  def food_trade_params
    params.require(:food_trade).permit(:description, :location, :category, :photo)
  end

  def food_trade_single_params
    params.permit(:food_trade[0]).permit(:description, :location, :category, :photo)
  end
end
