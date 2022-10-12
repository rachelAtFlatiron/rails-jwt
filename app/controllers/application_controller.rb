class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authorized

    def auth_header 
        request.headers['Authorization']
    end 
    def authorized
        if(auth_header)
            token = auth_header.split(' ')[1]
            JWT.decode(token, 'secret', true, algorithm: 'SHA256')
            #puts "user is #{user_id}"
        end 
    end 
end
