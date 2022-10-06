class SessionsController < ApplicationController
    #skip authorizing when attempting to login aka create a session
    skip_before_action :authorize, only: :create 
    skip_before_action :verify_authenticity_token

    def create #login 
        user = User.find_by(username: params[:username])
        #user& is to run the block authenticate ?
        if user&.authenticate(params[:password])
            session[:user_id] = user.id 
            render json: user 
        else
            render json: { errors: ["Invalid username or password"] }, status: :unauthorized
        end 
    end 

    def destroy #logout
        session.delete :user_id #delete this column/info from session
        head :no_content
    end 
end
