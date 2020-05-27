class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chatroom

  validates :content, presence: true
  validates :user, presence: true
  validates :chatroom, presence: true
end
