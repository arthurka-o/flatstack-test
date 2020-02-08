require 'rails_helper'

resource 'Tasks' do
  let!(:project) { create :project, title: 'title' }
  let(:expected_response) { { id: project.id, title: project.title } }

  get '/api/v1/projects' do
    example 'Listing projects' do
      do_request

      expect(status).to eq 200
      expect(json_response_body).to eq([expected_response])
    end
  end

  post '/api/v1/projects' do
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
