class FoodTrade < ApplicationRecord
  belongs_to :user_owned_ingredient
  has_many :chatrooms

  validates :status, inclusion: { in: ["Available", "Unavailable"]}
  validates :user_owned_ingredient, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :category, presence: true, inclusion: { in: ["Veggies", "Fruits", "Dairy", "Meats", "Other"]}
end
