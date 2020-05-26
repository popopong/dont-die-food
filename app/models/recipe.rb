class Recipe < ApplicationRecord
  has_many :ingredients, through :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :data, presence: true

end
