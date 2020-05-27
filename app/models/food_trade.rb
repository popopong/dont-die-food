class FoodTrade < ApplicationRecord
  belongs_to :user_owned_ingredient

  validates :status, presence: true
  validates :user_owned_ingredient, presence: true
  validates :location, presence: true
end
