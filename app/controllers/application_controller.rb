class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authorized

    def auth_header 
        request.headers['Authorization']
    end 
    
    def authorized
        if(auth_header)
            token = auth_header.split(' ')[1]
            id = JWT.decode(token, nil, false)

            puts "token #{id[0]['user_id']}"
            @user = User.find_by(id: id[0]['user_id'])
            render json: {user: @user, token: token}
        end 
    end 
end
