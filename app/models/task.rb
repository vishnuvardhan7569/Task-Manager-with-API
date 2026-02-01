class Task < ApplicationRecord
  STATUSES = %w[not_started in_progress completed].freeze
  TRANSITIONS = {
    "not_started" => %w[in_progress completed],
    "in_progress" => %w[completed],
    "completed" => []
  }.freeze

  belongs_to :project

  validates :title, presence: true, uniqueness: { scope: :project_id, message: "must be unique within this project" }
  validates :description, length: { maximum: 2000 }, allow_nil: true
  validates :status, inclusion: { in: STATUSES }
  validate :valid_status_transition, on: :update

  private

  def valid_status_transition
    return if status_was.nil? || status == status_was
    allowed = TRANSITIONS[status_was] || []
    errors.add(:status, "cannot transition from #{status_was} to #{status}") unless allowed.include?(status)
  end
end
