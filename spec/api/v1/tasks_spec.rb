require 'rails_helper'

resource 'Tasks' do
  let!(:project) { create :project, title: 'title' }
  let(:project_id) { project.id }
  let!(:task) { create :task, project: project }
  let(:task_id) { task.id }

  get '/api/v1/projects/:project_id/tasks' do
    example 'Listing tasks of the project' do
      do_request

      expect(status).to eq 200
      expect(json_response_body.first).to be_a_task_representation(task)
    end
  end

  post '/api/v1/projects/:project_id/tasks' do
    let(:number_of_tasks_after_request) { project.tasks.size }
    let!(:number_of_tasks) { project.tasks.size }

    context '200' do
      let(:request) { { task: { content: 'Test content' } } }

      example 'Create task with good data' do
        do_request(request)

        expect(status).to eq 201
        expect(json_response_body).to be_a_task_representation(task)
        expect(number_of_tasks + 1).to eq(number_of_tasks_after_request)
      end
    end

    context '400' do
      let(:request) { { task: { content: nil } } }

      example 'Create task with bad data' do
        do_request(request)

        expect(status).to eq 400
        expect(number_of_tasks).to eq(number_of_tasks_after_request)
      end
    end
  end

  get '/api/v1/projects/:project_id/tasks/:task_id' do
    context '200' do
      example 'Get task by id' do
        do_request

        expect(status).to eq(200)
        expect(json_response_body).to be_a_task_representation(task)
      end
    end
  end

  patch '/api/v1/projects/:project_id/tasks/:task_id' do
    context '200' do
      let(:request) { { task: { content: 'New content' } } }

      example 'Update task with good data by id' do
        do_request(request)

        expect(status).to eq 200
        expect(json_response_body).to be_a_task_representation(task)
        expect(task.reload.content).to eq('New content')
      end
    end

    context '400' do
      let(:request) { { task: { content: nil } } }
      let!(:old_content) { task.content }

      example 'Update task with bad data by id' do
        do_request(request)

        expect(status).to eq 400
        expect(old_content).to eq(task.reload.content)
      end
    end
  end
end
