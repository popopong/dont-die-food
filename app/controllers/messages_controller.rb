class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    if @message.save!
      redirect_to chatroom_path(@message.chatroom.id)
    else
      render "chatrooms/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :chatroom_id, :sender_id, :receiver_id)
  end
end
