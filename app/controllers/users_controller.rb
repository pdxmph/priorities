class UsersController < ApplicationController

  def show
    @user = User.friendly.find(params[:id])
    @title = "#{@user.fullname}"
  end

  def index
    @title = "Users"
    @users = User.order(fullname: :asc)
  end
  
end
