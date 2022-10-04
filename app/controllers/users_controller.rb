class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] ||= user.id
      render json: user, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def show
    unless session[:user_id] || session[:user_id].to_i < 1
      render json: nil, status: :unauthorized
    end
    user = User.find session[:user_id].to_i
    if user
      render json: user, status: :ok
    else
      render json: {
        errors: ["user is unauthorized"]
      }, status: :unauthorized
    end
  end

  private
  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

end
