
class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create] # Let users sign up without auth
  
    def create
      @user = User.new(user_params)
      if @user.save
        token = JWT.encode({ user_id: @user.id }, Rails.application.config.secret_key_base, 'HS256')
        render json: { user: @user, token: token }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :first_name, :last_name, :password, :password_confirmation)
    end
  end
  