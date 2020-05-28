class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :chatroom

  validates :content, :sender, :receiver, :chatroom, presence: true
end
