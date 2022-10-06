class UsersController < ApplicationController
    #skip authorizing when creating new user 
    skip_before_action :authorize, only: :create
    skip_before_action :verify_authenticity_token, only: :create
    def create 
        user = User.create!(user_params)
        session[:user_id] = user.id 
        render json: user, status: :created 
    end 

    def show 
        #current user gets set in application record as global
        render json: @current_user 
    end 

    private 

    def user_params 
        params.permit(:username, :password, :password_confirmation, :email)
    end 
end
