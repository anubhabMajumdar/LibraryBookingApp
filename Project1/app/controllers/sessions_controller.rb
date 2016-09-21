class SessionsController < ApplicationController

  def new
  end

  def create
    input_email = (params[:session][:email]).downcase
    input_password = (params[:session][:password])
    user = User.find_by(email: input_email)

    if user && user.authenticate(input_password)
      flash[:success] = "Successful Login"
      logging_in(user.id)
      redirect_to user_url(user)
    else
      flash.now[:danger] = "Wrong email/password combination"
      render 'new'
    end
  end

  def destroy
    logging_out
    redirect_to login_url
  end

end
