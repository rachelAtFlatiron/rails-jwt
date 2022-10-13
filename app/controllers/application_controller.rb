class ApplicationController < ActionController::Base
    rescue_from User::NotAuthorized, with: :deny_access
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    protect_from_forgery with: :null_session #avoids CSRF error
    before_action :authorized #calls and checks if authorized method passes

    #asks the question is user logged in
    def logged_in_user
        headers = request.headers['Authorization']
        if(headers)
            token = headers.split(' ')[1]
            cur_id = JWT.decode(token, 'secret', true, algorithm: 'HS256')
            @current_user = User.find_by(id: cur_id[0]["user_id"])
            @current_user
        end 
    end 

    #throws error if not logged in
    def authorized 
        puts "checking... #{logged_in_user}"
        # !! converts a value to boolean
        render json: { message: 'Please log in' }, status: :unauthorized unless !!logged_in_user
    end 

    #messages for errors 
    private 

    def deny_access
        head :forbidden
    end

    def unprocessable_entity(exception)
        render json: {"errors": exception.record.errors.full_messages}, status: :unprocessable_entity
    end

    def not_found 
        render json: {"error": "not found"}, status: 404
    end 
end
