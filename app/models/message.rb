class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :chatroom

  validates :content, :sender, :receiver, :chatroom, presence: true

  def other_user(current_user)
    if current_user == self.sender
      return self.receiver
    else
      return self.sender
    end
  end

end
