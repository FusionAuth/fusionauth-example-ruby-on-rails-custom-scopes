class SessionsController < ApplicationController
  def failure
    # Your failure handling logic goes here
    #redirect_to root_path, alert: "Authentication failed."
    #redirect_back(fallback_location: '/')
    redirect_to "/get_balance"
  end
end