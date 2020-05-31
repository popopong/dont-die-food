class FoodTrade < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  belongs_to :user_owned_ingredient
  has_many :chatrooms

  validates :status, inclusion: { in: ["Available", "Unavailable"]}
  validates :user_owned_ingredient, presence: true
  validates :location, presence: true
  validates :description, presence: true
  validates :category, presence: true, inclusion: { in: ["Veggies", "Fruits", "Dairy", "Meats", "Other"]}
end
