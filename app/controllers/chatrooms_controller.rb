class ChatroomsController < ApplicationController
  def index
    @messages = Message.order(created_at: :desc)
                        .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                        .uniq{ |message| message.sender_id }
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @other_user = @chatroom.other_user(current_user)
    @message = Message.new()
  end

  def update
    @chatroom = Chatroom.find(params[:id])
    @chatroom.update(chatroom_params)
    if @chatroom.save
      redirect_to :show
    else
      render :show
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:starred, :sender_id, :receiver_id)
  end
end
