class UsersController < ApplicationController

    def logged_in_user
        render json: current_user, except: [:password_digest], status: :ok
    end
end
