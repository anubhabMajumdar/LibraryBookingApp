class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end


  def create
    @user = User.new(allowed_params)
    if @user.save
      flash[:success] = ("Registration successful " + @user.name)
      redirect_to user_url(@user)
    else
      render 'users/new'
    end
  end

  private

    def allowed_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end