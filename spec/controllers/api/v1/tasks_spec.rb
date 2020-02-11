require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Tasks' do
  explanation 'Tasks resource'

  header 'Content-Type', 'application/json'

  let(:raw_post) { params.to_json }

  let!(:project) { create :project, title: 'title' }
  let(:project_id) { project.id }
  let!(:task) { create :task, project: project }
  let(:task_id) { task.id }

  get '/api/v1/projects/:project_id/tasks' do
    example_request 'Listing tasks of the project' do
      expect(status).to eq 200
      expect(json_response_body).to be_kind_of(Array)
      expect(json_response_body.first).to be_a_task_representation(task)
    end
  end

  post '/api/v1/projects/:project_id/tasks' do
    with_options scope: :task do
      parameter :content, 'Content of the task', required: true
      parameter :position, 'Position of task in the project'
      parameter :done, 'Shows if task is marked as done'
    end

    let(:number_of_tasks_after_request) { project.tasks.size }
    let!(:number_of_tasks) { project.tasks.size }

    context 'when data is correct' do
      let(:params) { { task: { content: 'Test content' } } }

      example 'Create task with a good data' do
        do_request(params)

        expect(status).to eq 201
        expect(json_response_body).to be_a_task_representation(task)
        expect(number_of_tasks + 1).to eq(number_of_tasks_after_request)
      end
    end

    context 'when data is bad' do
      let(:params) { { task: { content: nil } } }

      example 'Create task with bad data' do
        do_request(params)

        expect(status).to eq 422
        expect(number_of_tasks).to eq(number_of_tasks_after_request)
      end
    end
  end

  get '/api/v1/projects/:project_id/tasks/:task_id' do
    example_request 'Get task by id' do
      expect(status).to eq(200)
      expect(json_response_body).to be_a_task_representation(task)
    end
  end

  patch '/api/v1/projects/:project_id/tasks/:task_id' do
    context 'when data is correct' do
      let(:params) { { task: { content: 'New content' } } }

      example 'Update task with good data by id' do
        do_request(params)

        expect(status).to eq 200
        expect(json_response_body).to be_a_task_representation(task)
        expect(task.reload.content).to eq('New content')
      end
    end

    context 'when data is bad' do
      let(:params) { { task: { content: nil } } }
      let!(:old_content) { task.content }

      example 'Update task with bad data by id' do
        do_request(params)

        expect(status).to eq 422
        expect(old_content).to eq(task.reload.content)
      end
    end
  end
end
