class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:message][:chatroom_id])
    @message = Message.new(message_params)

    @chatroom = Chatroom.find(params[:message][:chatroom_id])
    @other_user = @chatroom.other_user(current_user)
    authorize @message

    @message.chatroom = @chatroom
    @message.sender = current_user

    if @message.save
      redirect_to chatroom_path(@message.chatroom.id, anchor: "message-#{
        @message.id}")
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "messages/received_message", locals: { message: @message })
      )
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
