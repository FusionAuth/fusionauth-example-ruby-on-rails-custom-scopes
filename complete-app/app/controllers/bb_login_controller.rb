class BbLoginController < ApplicationController

  skip_before_action :authenticate_user!

  class BbUser
    attr_accessor :id, :first_name, :email
    
    def initialize(id, first_name, email)
      @id = id
      @first_name = first_name
      @email = email
    end
  end

  def index

    #if session[:bb_user].nil?
    if !params[:user_email].nil? && !params[:user_email].blank?
      user = BbUser.new(1, "Charlie", params[:user_email])
      session[:bb_user] = user
      redirect_to "/balance_budget"
    end  
  end

end
