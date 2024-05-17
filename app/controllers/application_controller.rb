class ApplicationController < ActionController::API

    include ActionController::Cookies

    wrap_parameters format: []

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response

    before_action :authenticate
    skip_before_action :authenticate, only: [:welcome]

    def welcome
        render json: { "message" => "Welcome to HIVE!" }
    end

    def authenticate
        unless logged_in?
          render json: { error: "Unauthorized", message: "Unauthorized access" }, status: :unauthorized
        end
      end
      
    def logged_in?
        !!current_user
    end
      
    def current_user
        @current_user ||= find_user_by_token
    end
      
    def find_user_by_token
        if cookies.signed[:user_jwt]
            decoded_token = decode_token(cookies.signed[:user_jwt])
            if decoded_token && !expired_token?(decoded_token)
                user_id = decoded_token.first['user_id']
                User.find(user_id)
            end
        end
    end

    def decode_token(token)
        secret_key = Rails.application.secrets.secret_key_base
        begin
          JWT.decode(token, secret_key, true, { algorithm: 'HS512' })
        rescue JWT::DecodeError
            nil
        end
    end

    def encode_token(payload)
        # Set the secret key used for signing the token
        secret_key = Rails.application.secrets.secret_key_base

        custom_header = {
        'alg': 'HS512',
        'typ': 'JWT',
        'exp': Time.now.to_i + 3600  # Expiry time in seconds (e.g., 1 hour from now)
        }
      
        # Encode the payload using the secret key and return the token
        JWT.encode(payload, secret_key, 'HS512', custom_header)
    end

    private

    def expired_token?(decoded_token)
        Time.at(decoded_token.last['exp']) < Time.now
      end

    def record_not_found_response
        render json: { error: "#{controller_name.classify} not found", message: "RESOURCE NOT FOUND" }, status: :not_found
    end

    def unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors, message: "UNPROCESSABLE ENTITY" }, status: :unprocessable_entity
    end
end
