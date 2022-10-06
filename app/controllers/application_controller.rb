class ApplicationController < ActionController::Base
    #allows us to use sessions
    include ActionController::Cookies 
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    #before any controller actions, authorize, unless specified in child controllers
    before_action :authorize 

    def authorize 
        #set global current user on any api call
        #needs to be in application controller since all other controllers 
        #need to check for authorization before taking action
        @current_user = User.find_by(id: session[:user_id])
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless @current_user
    end 

    #private 
    private 

    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end 
end
