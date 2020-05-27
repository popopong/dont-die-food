class FoodTradesController < ApplicationController
  before_action find_user

  def index
    @food_trades = FoodTrade.where(user: @user)
  end

  def show

  end

  def new
  end

  def create
  end

  def destroy
  end

  def update
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
