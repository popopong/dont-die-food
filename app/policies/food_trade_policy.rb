class FoodTradePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def destroy?
    user_is_owner?
  end

  def edit?
    user_is_owner?
  end

  def update?
    user_is_owner?
  end
  
  def user_food_trades?
    trade_owner?
  end

  def veggies?
    true
  end

  def fruits?
    true
  end

  def dairy?
    true
  end

  def meats?
    true
  end

  def other?
    true
  end


  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def trade_owner?
    record.each { |rec| rec.user_owned_ingredient.user == user } 
  end

  def user_is_owner?
    record.user_owned_ingredient.user == user
  end
end
