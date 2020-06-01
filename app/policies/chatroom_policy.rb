class ChatroomPolicy < ApplicationPolicy
  def show?
    own_chatroom?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
  def own_chatroom?
    record.food_trade.user_owned_ingredient.user == user
  end
end
