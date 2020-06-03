class PantryItemPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  private
    def owner?
      record.each {|r| r.user == user }
    
      
    def user_is_owner?
      record.user == user
    end
end
