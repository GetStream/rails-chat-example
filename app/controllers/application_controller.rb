class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_token

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def user_token
    @user_token = session[:chat_token]
  end
end
