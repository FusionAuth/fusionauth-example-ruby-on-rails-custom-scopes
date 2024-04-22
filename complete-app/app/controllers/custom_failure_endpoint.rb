class CustomFailureEndpoint < OmniAuth::FailureEndpoint
  def call
    redirect_to '/get_balance'
  end
end

