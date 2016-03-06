class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = "#{@user.email}"
  end

  def index
    @title = "Users"
    @users = User.all
  end
  
end
