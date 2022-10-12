class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    before_action :authorized
    def authorized
        headers = request.headers['token']
        puts "hello #{headers}" 
    end 
end
