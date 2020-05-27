class Chatroom < ApplicationRecord
  belongs_to :food_trade
  has_many :messagess

  validates :food_trade, presence: true
  validates :starred, presence: true
end
