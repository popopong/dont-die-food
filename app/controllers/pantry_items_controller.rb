class PantryItemsController < ApplicationController
  def index
    @pantry_items = PantryItem.includes([:ingredient]).where(user: current_user)
  end

  def create
    @pantry_item = PantryItem.new(pantry_item_params)
    @pantry_item.user = current_user

    if @pantry_item.save!
      UserOwnedIngredient.find_or_create_by(user: current_user, ingredient_id: params[:pantry_item][:ingredient_id])
      
      pantry_array = ["🧂", "🧈", "🥛", "🧅", "🥜", "🍞"]
      flash.notice = "#{pantry_array.sample} Food trade successfully added!"
      redirect_to pantry_items_path
    else
      # Redirect to pantry_items index page for now because don't know how to render popup
      redirect_to pantry_items_path
    end
  end

  def destroy
    @pantry_item = PantryItem.find(params[:id])

    @pantry_item.destroy
    redirect_to pantry_items_path
  end

  private
  def pantry_item_params
    params.require(:pantry_item).permit(:ingredient_id)
  end
end
