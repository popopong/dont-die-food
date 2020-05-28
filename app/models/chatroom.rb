class Chatroom < ApplicationRecord
  belongs_to :food_trade
  has_many :messages

  validates :food_trade, presence: true
end
