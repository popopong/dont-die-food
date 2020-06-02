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
    trade_owner?
  end

  def edit?
    trade_owner?
  end

  def update?
    trade_owner?
  end
  
  def user_food_trades?
    trade_owner?
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
end
