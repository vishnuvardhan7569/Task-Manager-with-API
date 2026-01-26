class User < ApplicationRecord
  has_secure_password

  GENDERS = %w[male female].freeze

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  before_validation { self.email = email.downcase if email.present? }

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
end
