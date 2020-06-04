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
      # scope.where("message.receiver_id = ? OR message.sender_id = ?", user.id, user.id)
    end
  end

  private
  def own_chatroom?
    # record.each {|r| r.sender == user }
    record.each { |rec| rec.find_by(sender: user) || rec.find_by(receiver: user) } 
    @messages.each { |m| m.find_by(sender: current_user) || m.find_by(receiver: current_user)}

  end
end
