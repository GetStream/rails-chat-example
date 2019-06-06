class ChatController < ApplicationController
  def index
    @rep_token = @chat.create_token('representative')
  end
end
