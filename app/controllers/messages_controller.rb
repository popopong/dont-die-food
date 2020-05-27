class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.chatroom = Chatroom.find(params[:chatroom_id])
    if @message.save
      redirect_to "chatrooms/show"
    else
      render "chatrooms/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
