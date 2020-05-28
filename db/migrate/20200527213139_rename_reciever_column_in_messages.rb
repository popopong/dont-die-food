class RenameRecieverColumnInMessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :messages, :reciever_id, :receiver_id
  end
end
