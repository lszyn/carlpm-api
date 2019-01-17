module V1
  class ProjectsController < ApplicationController
    before_action :set_project, only: %i[show update destroy]

    def index
      json_response collection
    end

    def create
      @project = collection.create!(project_params)
      json_response(@project, :created)
    end

    def show
      json_response(@project)
    end

    def update
      @project.update(project_params)
      json_response @project
    end

    def destroy
      @project.destroy
      head :no_content
    end

    private

    def project_params
      params.require(:project).permit(:title, :description)
    end

    def set_project
      @project = collection.find(params[:id])
    end

    def collection
      @collection ||= current_user.projects
    end

    def serializer
      V1::ProjectSerializer
    end
  end
end
