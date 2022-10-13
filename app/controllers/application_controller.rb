class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authorized

    def auth_header 
        request.headers['Authorization']
    end 
    
    def authorized
        #if auth header exists
        if(auth_header)
            #get token value
            token = auth_header.split(' ')[1]
            id = JWT.decode(token, nil, false)


            puts "token #{id[0]['user_id']}"

            #find user by decoded token
            @user = User.find_by(id: id[0]['user_id'])
            #return
            @current_user = @user
        end 
    end 
end
