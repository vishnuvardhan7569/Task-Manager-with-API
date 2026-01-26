class ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header&.split&.last

    if token
      begin
        payload = decode_token(token)
        @current_user = User.find(payload["user_id"])
      rescue JWT::DecodeError => e
        render json: { error: "Token Invalid: #{e.message}" }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User not found" }, status: :unauthorized
      end
    else
      render json: { error: "Authorization token missing" }, status: :unauthorized
    end
  end

  def record_not_found(e)
    render json: { error: "#{e.model} not found" }, status: :not_found
  end

  def record_invalid(e)
    render json: {
      error: "Validation failed",
      errors: e.record.errors.full_messages
    }, status: :unprocessable_entity
  end
end
