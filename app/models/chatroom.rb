class Chatroom < ApplicationRecord
  belongs_to :food_trade
  has_many :messages

  validates :food_trade, presence: true

  def other_user(current_user)
    self.messages.first.other_user(current_user)
  end
end
