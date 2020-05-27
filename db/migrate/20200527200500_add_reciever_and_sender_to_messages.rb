class AddRecieverAndSenderToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :sender, foreign_key: { to_table: "users"}
    add_reference :messages, :reciever, foreign_key: { to_table: "users"}
  end
end
