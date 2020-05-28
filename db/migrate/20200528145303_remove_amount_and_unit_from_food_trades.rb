class RemoveAmountAndUnitFromFoodTrades < ActiveRecord::Migration[6.0]
  def change
    remove_column :food_trades, :amount
    remove_column :food_trades, :unit
  end
end
