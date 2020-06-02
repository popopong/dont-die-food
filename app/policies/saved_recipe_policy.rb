class SavedRecipePolicy < ApplicationPolicy
  def index?
    owned_by_user?
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
  def owned_by_user?
    record.each {|r| r.user == user }
  end
end
