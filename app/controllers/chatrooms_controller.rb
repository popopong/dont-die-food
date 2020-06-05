class ChatroomsController < ApplicationController

  def index
    @title = "My chats - Don't Die Food"
    @messages = policy_scope(Message).includes({chatroom: {food_trade: {user_owned_ingredient: :ingredient}}}, {sender: :photo_attachment}, {receiver: :photo_attachment})
                       .order(created_at: :desc)
                       .where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
                       .uniq{ |message| message.sender_id && message.chatroom_id }
    authorize @chatroom = policy_scope(Chatroom)
  end

  def show
    @chatroom = Chatroom.includes(messages: {sender: {photo_attachment: :blob}}).find(params[:id])
    @other_user = @chatroom.other_user(current_user)
    @title = "Messages with #{@other_user.first_name} - Don't Die Food"
    @message = Message.new
    authorize @chatroom
  end

  def create
    @food_trade = FoodTrade.find(params[:food_trade_id])
    authorize (@food_trade)
    # If there's a chatroom where there's one message from me and for the same food trade, then go to that chatroom (and don't create a new one)
    
    if chatroom_exists
      redirect_to chatroom_path(chatroom_exists)
    else
      @chatroom = Chatroom.new(food_trade: @food_trade)
      @chatroom.messages.new(sender: current_user, receiver: @food_trade.user_owned_ingredient.user, chatroom: @chatroom, content: "Chatroom successfully created (this is an automated message).")
      authorize @chatroom
      if @chatroom.save
        redirect_to chatroom_path(@chatroom)
      else
        redirect_to food_trade_path(params[:id])
      end
    end
  end

  def update
    @chatroom = Chatroom.find(params[:id])
    @chatroom.update(chatroom_params)
    authorize @chatroom
    
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

  def chatroom_exists
    if Chatroom.find_by(food_trade: @food_trade)
      if Chatroom.find_by(food_trade: @food_trade).messages.find_by(sender: current_user) 
        Chatroom.find_by(food_trade: @food_trade).id
      end
    end
  end
end
