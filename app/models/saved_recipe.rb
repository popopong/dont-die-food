class SavedRecipe < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :user, presence: true
  validates :recipe, presence: true, uniqueness: true
end
