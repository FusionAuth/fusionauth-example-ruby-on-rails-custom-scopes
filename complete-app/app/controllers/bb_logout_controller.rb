class BbLogoutController < ApplicationController
  def index
    session[:bb_user] = nil
    params[:user_email] = nil
    session[:user] = nil
    params.delete(:user_email)
    cookies[:jwt_token] = nil
    redirect_to "/"
  end
end
