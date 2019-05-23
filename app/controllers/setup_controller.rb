class SetupController < ApplicationController
  def new
  end

  def create
    session[:rep_id] = params[:handle].blank? ? "representative" : params[:handle]
    session[:rep_token] = @chat.create_token(session[:rep_id])
    redirect_to root_url
  end
end
