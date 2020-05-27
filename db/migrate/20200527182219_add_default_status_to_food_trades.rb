class AddDefaultStatusToFoodTrades < ActiveRecord::Migration[6.0]
  def change
    change_column_default :food_trades, :status, 'Available'
  end
end
