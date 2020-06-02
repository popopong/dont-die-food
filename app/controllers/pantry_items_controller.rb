class PantryItemsController < ApplicationController
  def index
    @pantry_items = PantryItem.includes([:ingredient]).where(user: current_user)
    @pantry_item = PantryItem.new
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

  def destroy
    @pantry_item = PantryItem.find(params[:id])

    @pantry_item.destroy
    redirect_to pantry_items_path
  end
end
