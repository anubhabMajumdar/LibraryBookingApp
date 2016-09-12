class UsersController < ApplicationController

  def show
    if user_logged_in?
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

  def edit
    if user_logged_in?
      @user = User.find(session[:user_id])

    else
      redirect_to login_path
    end
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update_attributes(allowed_params)
      flash[:success] = "Update successful"
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end


  private

    def allowed_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end