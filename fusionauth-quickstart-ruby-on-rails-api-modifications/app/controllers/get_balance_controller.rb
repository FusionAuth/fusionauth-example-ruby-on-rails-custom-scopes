class GetBalanceController < ApplicationController
  def index

    jwt_payload = request.env['jwt.payload']
    aud = jwt_payload["aud"]
    scope_string = jwt_payload["scope"]
    scopes = scope_string.split(" ")
    change_bank_user_id = jwt_payload["sub"]
    balance = nil
    success = false
    message = nil

    #Do we need to Introspect Token or is jwt_rack validation enough
    if !jwt_payload.blank?
        if (aud == ENV['BUDGET_BUDDY_CLIENT_ID'])
          if scopes.include?('balance:read')
            #This is hwere you would use the change_bank_user_id to look up their balance
            balance = "$100.32"
            success = true
          else
            message = "You do not have the correct balance:read scope."
          end
        end
    else
      message = "Token was empty, authorization failed."
    end

    output = {
          balance: balance,
          jwt: jwt_payload,
          aud: aud,
          change_bank_user_id: change_bank_user_id,
          scopes: scope_string,
          success: success,
          message: message
        }
    
    render json: output.to_json, status: :ok
  end
end