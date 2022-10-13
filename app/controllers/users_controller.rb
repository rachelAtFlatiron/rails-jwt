class UsersController < ApplicationController
    before_action :authorized, only: [:show]

    def create #for /signup
        @user = User.create!(user_params)
        token = JWT.encode({user_id: @user.id}, 'secret')
        render json: {user: @user, token: token}
    end 

    def show #for /me
        #@current_user comes from application_controller
        render json: {user: @current_user}
    end 

    def logout 
        @current_user = nil
        head :no_content
    end 

    def login #for /login
        #find by username from body
        @user = User.find_by(username: params[:username])
        #check if user exists and password matches password digest
        if (@user && @user.authenticate(params[:password]))
            #create token for front end
            token = JWT.encode({user_id: @user.id}, 'secret')
            #pass user instance and token to front end
            render json: {user: @user, token: token}
        end 
    end 

    private 

    def user_params 
        params.permit(:username, :password, :email)
    end 
end
