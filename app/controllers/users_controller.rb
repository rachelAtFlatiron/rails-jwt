class UsersController < ApplicationController
    before_action :authorized, only: [:show]
    def create
        @user = User.create!(user_params)
        token = JWT.encode({user_id: @user.id}, nil, 'none')
        render json: {user: @user, token: token}
    end 

    def show
        render json: {user: @current_user}
    end 

    def login 
        token = JWT.encode({user_id: @current_user.id}, nil, 'none')
        render json: {user: @current_user, token: token}
    end 

    private 

    def user_params 
        params.permit(:username, :password, :email)
    end 
end
