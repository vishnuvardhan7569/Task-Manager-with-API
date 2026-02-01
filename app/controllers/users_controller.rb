class UsersController < ApplicationController
  def me
    render json: {
      id: @current_user.id,
      email: @current_user.email,
      name: @current_user.name,
      gender: @current_user.gender
    }
  end

  def destroy
    @current_user.destroy
    render json: { message: "Account deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { error: "Failed to delete account" }, status: :unprocessable_entity
  end
end
