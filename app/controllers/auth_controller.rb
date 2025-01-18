class AuthController < ApplicationController
  require "jwt"

  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Registro de usuario
  def register
    user = User.new(user_params)

    if user.save
      # Enviar el código de verificación al correo del usuario
      UserMailer.verification_email(user).deliver_later
      render json: { message: "User registered successfully. Please check your email for the verification code." }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Verificación del correo electrónico
  def verify_email
    user = User.find_by(email: params[:email])

    if user&.verification_code == params[:verification_code]
      user.update(email_verified: true, verification_code: nil) # Marcar email como verificado y limpiar el código
      render json: { message: "Email verified successfully" }, status: :ok
    else
      render json: { error: "Invalid verification code or email" }, status: :unprocessable_entity
    end
  end

  # Inicio de sesión
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.email_verified
        token = generate_token(user)
        render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
      else
        render json: { error: "Email not verified" }, status: :unauthorized
      end
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  # Generar token JWT
  def generate_token(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY)
  end

  # Filtro de parámetros permitidos
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
