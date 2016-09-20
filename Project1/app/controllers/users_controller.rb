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

  def show_admins
    if user_logged_in?
      @all_admins = User.get_admins
    else
      redirect_to login_path
    end
  end

  def add_admin
    @admin_user = User.new
  end

  def search_admin
    # debugger
    @user_search = User.where(return_email).all
    if @user_search[0]!=nil
      flash.now[:success] = "#{@user_search[0].email} matched"
      @search_result = @user_search[0]
      @admin_user = @user_search[0]
    else
      flash.now[:danger] = "Email not found"
      @admin_user = User.new
    end
    render 'add_admin'
  end

  def make_admin
    # debugger
    @user_for_admin = User.find_by(email: params[:email])
    if @user_for_admin.Admin
      flash.now[:danger] = "#{@user_for_admin.name} already an admin"
    else
      # @user_for_admin.Admin = true
      if @user_for_admin.update_attribute(:Admin, true)
        flash.now[:success] = "#{@user_for_admin.name} successfully added as admin"
      else
        flash.now[:danger] = "Cannot be added as admin. Please try again"
      end
    end
    @admin_user = User.new
    render  'add_admin'
  end

  def remove_admin
    # debugger
    @user_for_admin = User.find_by(email: params[:email])
    if @user_for_admin.update_attribute(:Admin, false)
        flash.now[:success] = "#{@user_for_admin.name} successfully removed as admin"
      else
        flash.now[:danger] = "Cannot be removed as admin. Please try again"
    end
    @all_admins = User.get_admins
    render  'show_admins'
  end

  private

    def allowed_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def return_email
      params.require(:user).permit(:email)
    end


end