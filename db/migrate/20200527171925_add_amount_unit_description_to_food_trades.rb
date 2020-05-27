class AddAmountUnitDescriptionToFoodTrades < ActiveRecord::Migration[6.0]
  def change
    add_column :food_trades, :amount, :integer
    add_column :food_trades, :unit, :string
    add_column :food_trades, :description, :text
  end
end
