class ProjectsController < ApplicationController
  include ProjectStats

  before_action :set_project, only: [ :show, :update, :destroy ]

  def index
    page = (params[:page] || 1).to_i
    limit = (params[:limit] || 10).to_i

    projects_scope = @current_user.projects
      .left_joins(:tasks)
      .select(
        "projects.*,
         COUNT(tasks.id) AS total_tasks,
         SUM(CASE WHEN tasks.status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks"
      )
      .group("projects.id")

    total_projects = @current_user.projects.count
    projects = projects_scope.offset((page - 1) * limit).limit(limit)

    render json: {
      projects: projects.map { |p| project_json(p) },
      total_projects: total_projects,
      page: page,
      limit: limit
    }
  end

  def show
    render json: project_json(@project)
  end

  def create
    project = @current_user.projects.create!(project_params)
    render json: project_json(project), status: :created
  end

  def update
    @project.update!(project_params)
    render json: project_json(@project)
  end

  def destroy
    @project.destroy
    render json: { project_summary: { total_projects: @current_user.projects.count } }
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:id])
  end

  def project_params
    params.permit(:name, :domain, :description)
  end

  def project_json(project)
    total = project.try(:total_tasks).to_i
    completed = project.try(:completed_tasks).to_i
    percent = total.positive? ? ((completed.to_f / total) * 100).round : 0

    {
      id: project.id,
      name: project.name,
      domain: project.domain,
      description: project.description,
      total_tasks: total,
      completed_tasks: completed,
      percent: percent
    }
  end
end
