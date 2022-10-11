class UsersController < ApplicationController

    before_action :authorized, only: [:show]

    def create 
        @user = User.create!(user_params)
        token = encode_token({user_id: @user.id})
        render json: {user: @user, token: token}
    end 


    def login 
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        end 
    end 

    def logout
        @user = nil
    end

    def show 
        render json: @current_user 
    end 

    private 

    def user_params 
        params.permit(:username, :password, :password_confirmation, :email)
    end 
end
