# only if you want a link instead of a button for login
#OmniAuth.config.allowed_request_methods = [:post, :get]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect,
  name: :fusionauth,
  scope: [:openid, :email, :profile, 'balance:read'],
  response_type: :code,
  issuer: Rails.configuration.x.fusionauth.issuer,
  ssl: false,
  client_options: {
    # discovery doesn't work with local development
    authorization_endpoint: Rails.configuration.x.fusionauth.issuer+"/oauth2/authorize",
    token_endpoint: Rails.configuration.x.fusionauth.issuer+"/oauth2/token",
    userinfo_endpoint: Rails.configuration.x.fusionauth.issuer+"/oauth2/userinfo",
    jwks_uri: Rails.configuration.x.fusionauth.issuer+"/.well-known/jwks.json",
    identifier: Rails.configuration.x.fusionauth.client_id,
    secret: ENV["OP_SECRET_KEY"],
    redirect_uri: 'http://localhost:3000/auth/fusionauth/callback',
    failure: "/auth/failure",
    send_nonce: false
  }

  on_failure do |env|
    CustomFailureEndpoint.new(env).redirect_to_failure
#    #error_type = env['omniauth.error.type']
#    #error_message = env['omniauth.error.message']
#    #redirect_to "/get_balance"
#    #Rack:Response.new
  end
  
end
