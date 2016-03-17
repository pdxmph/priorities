class UsersController < ApplicationController
  before_action :require_admin, only: [:edit, :index]

  def show
    @user = User.find(params[:id])
    @title = "#{@user.email}"
  end

  def index
    @title = "Users"
    @users = User.all
  end


  def edit
    @user = User.find(params[:id])
    @title = @user.email
  end


  def update
    
    @user = User.find(params[:id])

    if params[:user][:password].blank?
        [:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
    else
      @user.errors[:base] << "The password you entered is incorrect" unless @user.valid_password?(params[:user][:current_password])
    end
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  
  private

  
  def require_admin
    unless current_user.try(:admin?)
      flash[:error] = "You must be an admin to access that page."
      redirect_to "/" 
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :id, :last_name, :email, :password, :password_confirmation)
  end
  
end
