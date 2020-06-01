class Recipe < ApplicationRecord
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :ingredients_data, presence: true
  validates :steps_data, presence: true
  validates :photo, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_title
    against: [ :title ]
    using: {
      tsearch: { prefix: true }
    }
end
