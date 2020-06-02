class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:message][:chatroom_id])
    @message = Message.new(message_params)
    @chatroom = Chatroom.find(params[:message][:chatroom_id])
    @other_user = @chatroom.other_user(current_user)
    
    authorize @message
    if @message.save
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
