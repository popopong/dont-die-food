class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :pantry_items, dependent: :destroy
  has_many :messages
  has_many :user_owned_ingredients
  has_many :food_trades, through: :user_owned_ingredients
  has_many :ingredients, through: :user_owned_ingredients
  has_many :saved_recipes
  has_one_attached :photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: /\w+@\w+\.[a-z]{2,4}\z/, message: "Please enter a valid email address"}
  validates :encrypted_password, presence: true

  def number_of_pantry_items_for(recipe)
    number = pantry_items.select do |pantry_item|
      recipe.ingredient_ids.include?( pantry_item.ingredient_id )
    end
    number.count
  end

  def sort_by_pantry_items(recipes)
    recipes.to_a.sort_by { |recipe| number_of_pantry_items_for(recipe) }.reverse
  end
end
