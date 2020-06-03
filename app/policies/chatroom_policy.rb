class ChatroomPolicy < ApplicationPolicy
  def index?
    own_chatroom?
  end

  def show?
    own_chatroom?
  end

  def update?
    own_chatroom?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
  def own_chatroom?
    record.food_trade.user_owned_ingredient.user == user ||
    record.messages.any? {|msg| msg.sender == user}
  end
end
