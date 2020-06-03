class UserPolicy < ApplicationPolicy
  def show?
    user_is_owner?
  end 

  def edit?
    user_is_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private
  def user_is_owner?
    record == user
  end
end
