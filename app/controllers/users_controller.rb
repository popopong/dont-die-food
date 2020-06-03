class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def show
    @user = current_user
    authorize @user
  end

  def edit
    authorize @user
  end

  def update

    if @user.update(user_params)
      flash.notice = "Profile successfully updated!"
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :address)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
