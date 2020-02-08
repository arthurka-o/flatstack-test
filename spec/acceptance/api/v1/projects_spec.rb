require 'rails_helper'

resource 'Projects' do
  let!(:project) { create :project, title: 'title' }
  let(:expected_response) { { id: project.id, title: project.title } }

  get '/api/v1/projects' do
    context '200' do
      example 'Listing projects' do
        do_request

        expect(status).to eq 200
        expect(json_response_body).to eq([expected_response])
      end
    end
  end

  post '/api/v1/projects' do
    context '201' do
      let(:request) do
        {
          project: {
            title: 'Test title'
          }
        }
      end
      let!(:number_of_projects) { Project.count }
      let(:number_of_projects_after) { Project.count }
      let(:last_project) { Project.last }

      example 'Create project' do
        do_request(request)

        expect(status).to eq 201
        expect(json_response_body[:title]).to eq(last_project.title)
        expect(number_of_projects + 1).to eq(number_of_projects_after)
      end
    end
  end

  get '/api/v1/projects/:id' do
    context '200' do
      let(:id) { project.id }

      example 'Get an project' do
        do_request

        expect(status).to eq(200)
        expect(json_response_body).to eq(expected_response)
      end
    end
  end

  patch '/api/v1/projects/:id' do
  end

  delete '/api/v1/projects/:id' do
  end
end
