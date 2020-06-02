class ChatroomsController < ApplicationController

  def index
    @messages = Message.includes({chatroom: {food_trade: {user_owned_ingredient: :ingredient}}}, :sender, :receiver)
                       .order(created_at: :desc)
                       .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                       .uniq{ |message| message.sender_id && message.chatroom_id }
  end

  def show
    @chatroom = Chatroom.includes(messages: :sender).find(params[:id])
    @other_user = @chatroom.other_user(current_user)
    @message = Message.new()
  end

  def create
    @chatroom = Chatroom.new(food_trade_id: params[:food_trade_id])

    if @chatroom.save!
      redirect_to chatroom_path(@chatroom)
    else
      redirect_to food_trade_path(params[:id])
    end
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
    params.require(:chatroom).permit(:starred, :food_trade_id)
  end
end
