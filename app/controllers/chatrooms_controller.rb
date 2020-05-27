class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.all
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
    params.require(:chatroom).permit(:starred)
  end
end
