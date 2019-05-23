require 'stream-chat'

class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_token

  def initialize
    if ENV['STREAM_URL'].blank?
      api_key = ENV['STREAM_API_KEY']
      api_secret = ENV['STREAM_API_SECRET']
    else
      api_key, api_secret = ENV['STREAM_URL'][8..].split('@')[0].split(':')
    end
    @chat = StreamChat::Client.new(api_key=ENV['STREAM_API_KEY'], api_secret=ENV['STREAM_API_SECRET'])
  end

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
