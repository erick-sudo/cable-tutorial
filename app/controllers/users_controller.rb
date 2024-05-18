class UsersController < ApplicationController

    skip_before_action :authenticate, only: [:job_test]

    def job_test
        CleanupJob.set(wait: 5.seconds).perform_later
        render json: { "success": "Job Running" }, status: :ok
    end

    def logged_in_user
        render json: current_user, except: [:password_digest], status: :ok
    end
end
