class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.includes(:messages)
    # chatrooms_including_current_user = Chatroom.all
    # @chatrooms = chatrooms_including_current_user.messages.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
  end

  def show
    @chatroom = Chatroom.find(params[:id])
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
