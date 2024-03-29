module SessionsHelper

  def sign_in(user)
    #if((params[:session]) && (params[:session][:remember].to_i != 0)) #to implement part 2 of assignment #9
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
   # else #to implement part 2 of assignment #9
      #cookies.signed[:remember_token] = [user.id, user.salt]
   # end
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  #def lastLogin
    #return time_ago_in_words(cookies[:lastSession])  # display how long ago last log-in time is
  #end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
end
