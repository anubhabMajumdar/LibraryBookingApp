class UsersController < ApplicationController

  def show
    if login_status?
      @user = User.find(session[:user_id])
    else
      redirect_to login_path
    end

  end

  def new
    @user = User.new
  end


  def create
    @user = User.new(allowed_params)
    @user.Admin = false
    if @user.save
      flash[:success] = ("Registration successful " + @user.name)
      logging_in(@user.id)
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  private

    def allowed_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :Admin)
    end


end