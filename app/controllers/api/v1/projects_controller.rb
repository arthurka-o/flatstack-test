class Api::V1::ProjectsController < ApplicationController
  expose :projects, -> { Project.order(created_at: :desc) }
  expose :project, build_params: :project_params

  def index
    render json: projects
  end

  def create
    if project.save
      render json: project
    else
      render json: project.errors
    end
  end

  def update
    if project.update(project_params)
      render json: project
    else
      render json: project.errors
    end
  end

  def destroy
    status = project.destroy ? 200 : 400
    head status
  end

  private

  def project_params
    params.require(:project).permit(:title)
  end
end
