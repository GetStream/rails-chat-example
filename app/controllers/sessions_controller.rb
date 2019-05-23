class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_handle(params[:handle])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:chat_token] = @chat.create_token(user.handle)
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now[:alert] = 'Handle or password is invalid'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:chat_token] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
