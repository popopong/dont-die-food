class ChatroomsController < ApplicationController

  def iterable?(object)
    object.respond_to? :each
  end

  def index
    @messages = Message.includes({chatroom: {food_trade: {user_owned_ingredient: :ingredient}}}, :sender, :receiver)
                       .order(created_at: :desc)
                       .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                       .uniq{ |message| message.sender_id }

    @chatrooms = Chatroom.select do |chatroom|
      chatroom.messages.order(created_at: :desc).select do |message|
        message.sender_id == current_user || message.receiver_id == current_user
      end
    end
  end

  def show
    @chatroom = Chatroom.includes(messages: :sender).find(params[:id])
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
