class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # the next 2 statements are here to  implement part 2 of assignment #9
      cookies.permanent[:lastSession] = user.updated_at   #(save last log-in time before updating it)  
      user.touch   #(update log-in time for this session)  
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
