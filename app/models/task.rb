class Task < ApplicationRecord
  STATUSES = %w[pending in_progress completed].freeze

  belongs_to :project

  validates :title, presence: true
  validates :description, length: { maximum: 2000 }, allow_nil: true
  validates :status, inclusion: { in: STATUSES }
end
