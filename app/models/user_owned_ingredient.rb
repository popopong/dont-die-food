class UserOwnedIngredient < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient
  has_many :food_trades

  validates :user, presence: true
  validates :ingredient, presence: true
end
