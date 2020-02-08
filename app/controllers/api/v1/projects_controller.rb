class Api::V1::ProjectsController < ApiController
  expose :projects, -> { Project.order(created_at: :desc) }
  expose :project, build_params: :project_params

  def index
    success(projects)
  end

  def show
    success(project)
  end

  def create
    if project.save
      success(project, 201)
    else
      error(project.errors)
    end
  end

  def update
    if project.update(project_params)
      success(project)
    else
      error(project.errors)
    end
  end

  def destroy
    if project.destroy
      success
    else
      error(project.errors)
    end
  end

  private

  def project_params
    params.require(:project).permit(:title)
  end
end
