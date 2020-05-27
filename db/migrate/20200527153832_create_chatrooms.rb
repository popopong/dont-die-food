class CreateChatrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chatrooms do |t|
      t.references :food_trade, null: false, foreign_key: true
      t.boolean :starred, default: false

      t.timestamps
    end
  end
end
