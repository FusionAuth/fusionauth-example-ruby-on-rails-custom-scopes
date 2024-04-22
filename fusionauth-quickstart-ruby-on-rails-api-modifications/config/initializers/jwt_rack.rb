require 'net/http'
require 'jwt'

source = ENV['FUSIONAUTH_LOCATION'] + '/.well-known/jwks.json'
resp = Net::HTTP.get_response(URI.parse(source))
data = resp.body
jwks_hash = JSON.parse(data)
jwks = JWT::JWK::Set.new(jwks_hash)
jwks.select! { |key| key[:use] == 'sig' } # Signing Keys only

p source

audiences = [ENV['CLIENT_ID'], ENV['BUDGET_BUDDY_CLIENT_ID']]

jwt_auth_args = {
      secret: nil,
      options: {
        cookie_name: 'app.at',
        iss: ENV['FUSIONAUTH_LOCATION'],
        verify_iss: true,
        aud: audiences,
        verify_aud: true,
        verify_iat: true,
        verify_expiration: true,
        required_claims: ['applicationId'],
        jwks: jwks,
        algorithm: 'RS256'
      }
}

Rails.application.config.middleware.use Rack::JWT::Auth, jwt_auth_args

