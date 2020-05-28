class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update

    if @user.update(user_params)
      redirect_to 'show'
    else
      render 'edit'
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
