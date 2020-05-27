class FoodTrade < ApplicationRecord
  belongs_to :user_owned_ingredient
  belongs_to :user, through: :user_owned_ingredient
  has_many :chatrooms

  validates :status, presence: true
  validates :user_owned_ingredient, presence: true
  validates :location, presence: true
end
