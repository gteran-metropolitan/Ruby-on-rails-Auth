class UsersController < ApplicationController

  before_action :authenticate_user!

  def profile
    render json: { user: { id: @current_user.id, email: @current_user.email } }, status: :ok
  end
end
