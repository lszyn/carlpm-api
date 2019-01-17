module V1
  class TasksController < ApplicationController
    before_action :set_project
    before_action :set_project_task, only: %i[show update destroy make_completed make_not_completed]

    def index
      json_response collection
    end

    def show
      json_response @task
    end

    def create
      @task = collection.create!(task_params)
      json_response(@task, :created)
    end

    def update
      @task.update(task_params)
      json_response @task
    end

    def make_completed
      @task.update!(done: true)
      json_response @task
    end

    def make_not_completed
      @task.update!(done: false)
      json_response @task
    end

    def destroy
      @task.destroy
      head :no_content
    end

    private

    def task_params
      params.require(:task).permit(:name, :done, :deadline)
    end

    def set_project
      @project = Project.find(params[:project_id])
    end

    def collection
      @collection ||= @project.tasks
    end

    def set_project_task
      @task ||= collection.find_by!(id: params[:id]) if @project
    end
  end
end
