class MessagePolicy < ApplicationPolicy
  def index?
    own_chatroom?
  end
  def create?
    true
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
  def own_chatroom?
    record.each {|r| r.sender == user }
  end
end
