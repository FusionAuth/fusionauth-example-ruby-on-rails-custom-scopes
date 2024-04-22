class AuthController < ApplicationController

  skip_before_action :authenticate_user!

  def logout
    session[:user] = nil
    cookies[:jwt_token] = nil
    redirect_to Rails.configuration.x.fusionauth.issuer+"/oauth2/logout?client_id="+Rails.configuration.x.fusionauth.client_id
  end

  def callback
    #session[:user] = request.env['omniauth.auth'].info
    auth_response = request.env['omniauth.auth']
    session[:user] = auth_response.info
    jwt = auth_response['credentials']['token']
    cookies[:jwt_token] = {
      value: jwt,
      expires: 1.hour.from_now, # Set an expiration time for the cookie
      secure: Rails.env.production?, # Ensure the cookie is only sent over HTTPS in production
      httponly: true # Ensure the cookie cannot be accessed by JavaScript
    }
    redirect_to '/get_balance'
  end
end
