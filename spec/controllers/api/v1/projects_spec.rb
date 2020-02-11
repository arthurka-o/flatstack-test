require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Projects' do
  explanation 'Projects resource'

  header 'Content-Type', 'application/json'

  let(:raw_post) { params.to_json }

  let!(:project) { create :project, title: 'title' }
  let(:id) { project.id }
  let(:last_project) { Project.last }

  get '/api/v1/projects' do
    example_request 'Getting a list of projects' do
      expect(status).to eq 200
      expect(json_response_body).to be_kind_of(Array)
      expect(json_response_body.first).to be_a_project_representation(project)
    end
  end

  post '/api/v1/projects' do
    parameter :title, 'The project title', required: true, scope: :project

    let!(:number_of_projects) { Project.count }
    let(:number_of_projects_after_request) { Project.count }

    context 'when data is correct' do
      let(:params) { { project: { title: 'Test title' } } }

      example 'Create project with a correct data' do
        do_request(params)

        expect(status).to eq 201
        expect(json_response_body).to be_a_project_representation(last_project)
        expect(number_of_projects + 1).to eq(number_of_projects_after_request)
      end
    end

    context 'when data is bad' do
      let(:params) { { project: { title: nil } } }

      example 'Create project with a bad data' do
        do_request(params)

        expect(status).to eq 422
        expect(number_of_projects).to eq(number_of_projects_after_request)
      end
    end
  end

  get '/api/v1/projects/:id' do
    example_request 'Get an project' do
      expect(status).to eq(200)
      expect(json_response_body).to be_a_project_representation(project)
    end
  end

  patch '/api/v1/projects/:id' do
    parameter :title, 'The project title', required: true, scope: :project

    context 'when data is correct' do
      let(:params) { { project: { title: 'Test title 2' } } }

      example 'Update project with a correct data' do
        do_request(params)

        expect(status).to eq 200
        expect(json_response_body).to be_a_project_representation(project)
        expect(project.reload.title).to eq('Test title 2')
      end
    end

    context 'when data is bad' do
      let(:params) { { project: { title: nil } } }
      let!(:old_title) { project.title }

      example 'Update project with a bad data' do
        do_request(params)

        expect(status).to eq 422
        expect(old_title).to eq(project.reload.title)
      end
    end
  end

  delete '/api/v1/projects/:id' do
    example_request 'Destroy the project' do
      expect(status).to eq 204
      expect { project.reload }.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
