class CreateFoodTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :food_trades do |t|
      t.string :status, default: "Available"
      t.references :user_owned_ingredient, null: false, foreign_key: true
      t.string :location

      t.timestamps
    end
  end
end
