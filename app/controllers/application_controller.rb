class ApplicationController < ActionController::Base
    #rescue_from User::NotAuthorized, with: :deny_access
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :show_record_errors
    before_action :authorized 
    #get rid of CSRF token error
    skip_before_action :verify_authenticity_token


    #return authorization header containing jwt token for decoding
    def auth_header 
        # { Authorization: 'Bearer <token>' }
        request.headers['Authorization']
    end

    #encode token to pass to front end session
    def encode_token(payload)
        JWT.encode(payload, 'secret')
    end 

    def decoded_token
        # header: { 'Authorization': 'Bearer <token>' }
        if auth_header 
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, 'secret', true, algorithm: 'HS256')
            rescue JWT::DecodeError 
                nil
            end
        end 
    end 

    #upon authorization and decoded token, set current user
    def logged_in_user
        if decoded_token 
            user_id = decoded_token[0]['user_id']
            @current_user = User.find_by(id: user_id)
        end 
    end 

    #try to log in user, returns true if successful
    def logged_in?
        !!logged_in_user 
    end 

    #throws error if not logged in
    def authorized 
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end 

    #messages for errors
    private
        def deny_access
            head :forbidden
        end

        def show_record_errors(exception)
            redirect_back_or_to root_url, alert: exception.record.errors.full_messages.to_sentence
        end

        def not_found 
            render json: {"error": "not found"}, status: 404
        end 
end
