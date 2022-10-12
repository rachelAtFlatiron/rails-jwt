class UsersController < ApplicationController
    before_action :authorized, only: [:show]
    def create
        user = User.create!(user_params)
        token = JWT.encode(user.id, 'secret', algorithm: 'RS256')
        render json: {user: user, token: token}
    end 

    def show
    end 

    private 

    def user_params 
        params.permit(:username, :password, :email)
    end 
end
