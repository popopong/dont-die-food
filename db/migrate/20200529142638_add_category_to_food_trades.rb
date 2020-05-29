class AddCategoryToFoodTrades < ActiveRecord::Migration[6.0]
  def change
    add_column :food_trades, :category, :string
  end
end
