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
    pantry_items.count do |pantry_item|
      recipe.ingredient_ids.include?( pantry_item.ingredient_id )
    end
  end
end
