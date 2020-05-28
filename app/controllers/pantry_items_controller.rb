class PantryItemsController < ApplicationController
  def index
    @pantry_items = PantryItem.where(user: current_user)
    # @pantry_items = PantryItem.includes(:ingredient).where(user: User.find(params[:user_id])) 
  end

  def create
    @pantry_item = PantryItem.new
    @pantry_item.user = current_user

    if @pantry_item.save
      redirect_to pantry "/users/:user_id/pantry_items"
    else
      # Redirect to pantry_items index page for now because don't know how to render popup
      render "/users/:user_id/pantry_items"
    end
  end
end
