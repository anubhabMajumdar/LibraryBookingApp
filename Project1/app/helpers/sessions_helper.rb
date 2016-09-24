module SessionsHelper

  def match_session_id(inpid)
    if user_logged_in?
      if inpid == session[:user_id]
        true
      else
        false
      end
    else
      false
    end
  end

  def logging_in(used_id)
    session[:user_id] = used_id
  end

  def logging_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if @current_user
      @current_user
    else
      if session[:user_id]                                          # For users who have logged in
        @current_user = User.find(session[:user_id])
      else                                                          # For users who haven't logged in
        @current_user = nil
      end
    end
  end

  def user_logged_in?
    if current_user
      true
    else
      false
    end
  end

  def allowed_user
    if not user_logged_in?
      redirect_to login_url
    end
  end

end
