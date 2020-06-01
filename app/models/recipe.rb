class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :ingredients_data, presence: true
  validates :steps_data, presence: true
  validates :photo, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_ing,
    against: [ :title ],
    associated_against: {
      ingredients: [ :name ]
    },
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

end
