class TasksController < ApplicationController
  include ProjectStats

  before_action :set_project
  before_action :set_task, only: [ :update, :destroy ]

  def index
    page = (params[:page] || 1).to_i
    limit = (params[:limit] || 10).to_i

    total_tasks = @project.tasks.count
    tasks = @project.tasks.order(:id).offset((page - 1) * limit).limit(limit)

    render json: {
      tasks: tasks.map { |t| task_json(t) },
      total_tasks: total_tasks,
      page: page,
      limit: limit
    }
  end

  def create
    task = @project.tasks.create!(task_params)
    render json: {
      task: task_json(task),
      project_summary: project_summary(@project)
    }, status: :created
  end

  def update
    @task.update!(task_params)
    render json: {
      task: task_json(@task),
      project_summary: project_summary(@project)
    }
  end

  def destroy
    @task.destroy
    render json: { project_summary: project_summary(@project) }
  end

  private

  def set_project
    @project = @current_user.projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def task_params
    params.permit(:title, :description, :status)
  end

  def task_json(task)
    { id: task.id, title: task.title, description: task.description, status: task.status }
  end
end
