class LoginController < ApplicationController

  skip_before_action :authenticate, only: [:login]

  def login
    user = User.find_by(username: login_params[:username])
    if user && user.authenticate(login_params[:password])
      token = encode_token(user_id: user.id)
      cookies.signed[:user_jwt] = { value: token, httponly: true, expires: 1.hour }

      render json: { message: "Login successful", access_token: token }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
