class ApplicationController < ActionController::API

  SECRET_KEY = Rails.application.credentials.secret_key_base

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded_token = decode_token(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
      render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  private

  def decode_token(token)
    return nil unless token
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
      HashWithIndifferentAccess.new(decoded[0])
    rescue JWT::DecodeError
      nil
    end
  end

end
