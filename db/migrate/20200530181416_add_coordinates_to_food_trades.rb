class AddCoordinatesToFoodTrades < ActiveRecord::Migration[6.0]
  def change
    add_column :food_trades, :latitude, :float
    add_column :food_trades, :longitude, :float
  end
end
