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
    @food_trade = FoodTrade.find(params[:food_trade_id])
    # If there's a chatroom where there's one message from me and for the same food trade, then go to that chatroom (and don't create a new one)
    if Chatroom.find_by(food_trade: @food_trade)
    end
    @chatroom = Chatroom.new(food_trade: @food_trade)
    @chatroom.messages.new(sender: current_user, receiver: @food_trade.user_owned_ingredient.user, chatroom: @chatroom, content: "Chatroom successfully created (this is an automated message).")

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
