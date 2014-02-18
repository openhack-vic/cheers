class UsersController < ApplicationController
  before_filter :authenticate_user!
  def index
    @users = User.find_all
  end
  
end
