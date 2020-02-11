class Api::V1::TasksController < ApiController
  expose :project
  expose :task, scope: -> { project.tasks }, build_params: :task_params
  expose :tasks, -> { project.tasks.order(position: :asc) }

  def index
    success(tasks)
  end

  def show
    success(task)
  end

  def create
    if task.save
      success(task, 201)
    else
      error(task.errors, 422)
    end
  end

  def update
    if task.update(task_params)
      success(task)
    else
      error(task.errors, 422)
    end
  end

  private

  def task_params
    params.require(:task).permit(:content, :position, :done)
  end
end
