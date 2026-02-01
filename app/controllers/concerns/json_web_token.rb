module JsonWebToken
  extend ActiveSupport::Concern

  SECRET_KEY = Rails.application.secret_key_base
  TOKEN_EXPIRATION = 2.hours

  def encode_token(payload)
    payload[:exp] = TOKEN_EXPIRATION.from_now.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def decode_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
  rescue JWT::ExpiredSignature
    { error: "Token expired" }
  rescue
    nil
  end
end
