class Api::V1::TasksController < ApplicationController
  expose :project
  expose :task, scope: -> { project.tasks }, build_params: :task_params
  expose :tasks, -> { project.tasks.order(position: :asc) }

  def index
    render json: tasks
  end

  def create
    if task.save
      render json: task
    else
      render json: task.errors
    end
  end

  def update
    if task.update(task_params)
      render json: task
    else
      render json: task.errors
    end
  end

  def destroy
    status = task.destroy ? 200 : 400
    head status
  end

  private

  def task_params
    params.require(:task).permit(:content, :position, :done)
  end
end
