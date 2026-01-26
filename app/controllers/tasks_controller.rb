class TasksController < ApplicationController
  # GET /projects/:project_id/tasks
  def index
    project = @current_user.projects.find(params[:project_id])
    render json: project.tasks
  end

  # POST /projects/:project_id/tasks
  def create
    project = @current_user.projects.find(params[:project_id])
    task = project.tasks.create!(task_params)
    render json: task, status: :created
  end

  # PATCH /tasks/:id
  def update
    task = @current_user.tasks.find(params[:id])
    task.update!(task_params)
    render json: task
  end

  # DELETE /tasks/:id
  def destroy
    task = @current_user.tasks.find(params[:id])
    task.destroy
    head :no_content
  end

  private

  def task_params
    params.permit(:title, :description, :status)
  end
end
