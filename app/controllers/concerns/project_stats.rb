module ProjectStats
  extend ActiveSupport::Concern

  def project_summary(project)
    total = project.tasks.count
    completed = project.tasks.where(status: "completed").count
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    {
      id: project.id,
      total_tasks: total,
      completed_tasks: completed,
      percent: percent
    }
  end
end
