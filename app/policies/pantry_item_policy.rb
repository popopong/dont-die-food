class PantryItemPolicy < ApplicationPolicy
  def index?
    owner?
  end

  def create?
    owner?
  end

  def destroy?
    owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  private
    def owner?
      record.each {|r| r.user == user }
    end
end
