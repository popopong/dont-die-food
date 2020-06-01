class MessagePolicy < ApplicationPolicy
  def create?
    own_chatroom?
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
  def own_chatroom?
    record.sender == user
  end
end
