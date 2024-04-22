class GetBalanceController < ApplicationController
     def index
          @balance = ""
          @email = ""
          @first_name = ""
          @scopes = ""
          @response_message = ""
          @success = false

          if defined? session[:user]
               @user_info = session[:user]
               @jwt = cookies[:jwt_token]
               if !@jwt.blank?
                    @decoded_token = JWT.decode(@jwt , nil, false) 
                    @scopes = @decoded_token[0]['scope']
                    @email = @user_info["email"]
                    @first_name = @user_info['first_name']

                    uri = URI.parse('http://localhost:4001/get-balance')
                    http = Net::HTTP.new(uri.host, uri.port)

                    request = Net::HTTP::Get.new(uri.request_uri)

                    @request = uri.request_uri
                    
                    request['Cookie'] = 'app.at=' + @jwt

                    response = http.request(request)

                    @response = response.body
                    #if valid response then good
                    json_response = @response
                    @parsed_response = JSON.parse(json_response)
                    @balance = @parsed_response["balance"]
                    @response_message = @parsed_response["message"]
                    @success = @parsed_response["success"]
                    @example_token = @parsed_response["example_token"]
                    @jwt_payload = @parsed_response["jwt"]
                    #@balance = 2
               else
                    @jwt = "empty"
               end
               
          end
     end

    
  
end
