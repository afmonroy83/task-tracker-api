module Api
  module V1
    class TasksController < ApplicationController
      def index
        tasks = Task.order(created_at: :desc)
        render_success(tasks)
      end

      def create
        task = Task.new(task_params)

        if task.save
          render_success(task, status: :created)
        else
          render_error(task.errors.full_messages, status: :unprocessable_content)
        end
      end

      private

      def task_params
        params.require(:task).permit(:description)
      end
    end
  end
end
