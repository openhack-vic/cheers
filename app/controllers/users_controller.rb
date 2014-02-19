class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @music = @user.music
  end

  private

  def user_params
    params.require(:user).permit(:name, :description, :email, :password, :password_confirmation, :current_password)
  end

end
