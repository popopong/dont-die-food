class PantryItemsController < ApplicationController
  def index
    @pantry_items = policy_scope(PantryItem).includes(:ingredient, :user).where(user: current_user)
    @pantry_item = PantryItem.new
    authorize @pantry_items

    @addable_items = Ingredient.all.map { |ing| [ing.name, ing.id] }.sort!
  end

  def create
    @pantry_item = PantryItem.new
    @pantry_item.user = current_user
    @pantry_item.ingredient_id = pantry_item_params[:ingredient_id]

    authorize @pantry_item
    if @pantry_item.save
      UserOwnedIngredient.find_or_create_by(user: current_user, ingredient_id: params[:pantry_item][:ingredient_id])
      redirect_to pantry_items_path
    else
      flash.notice = "Item already in your pantry!"
      redirect_to pantry_items_path
    end
  end

  def destroy
    @pantry_item = PantryItem.find(params[:id])
    authorize @pantry_item

    @pantry_item.destroy
    redirect_to pantry_items_path
  end

  private
  def pantry_item_params
    params.require(:pantry_item).permit(:ingredient_id)
  end
end
