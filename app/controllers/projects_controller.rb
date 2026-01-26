class ProjectsController < ApplicationController
  before_action :set_project, only: [ :show, :update, :destroy ]

  def index
    projects = @current_user.projects
      .left_joins(:tasks)
      .select(
        "projects.*,
         COUNT(tasks.id) AS total_tasks,
         SUM(CASE WHEN tasks.status = 'completed' THEN 1 ELSE 0 END) AS completed_tasks"
      )
      .group("projects.id")

    render json: projects.as_json(
      methods: [ :total_tasks, :completed_tasks ]
    )
  end

  def show
    render json: @project
  end

  def create
    project = @current_user.projects.create!(project_params)
    render json: project, status: :created
  end

  def update
    @project.update!(project_params)
    render json: @project
  end

  def destroy
    @project.destroy
    head :no_content
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:id])
  end

  def project_params
    params.permit(:name, :domain, :description)
  end
end
