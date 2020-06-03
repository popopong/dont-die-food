class PantryItem < ApplicationRecord
  belongs_to :user
  belongs_to :ingredient

  validates :ingredient_id, presence: true, uniqueness: true
end
