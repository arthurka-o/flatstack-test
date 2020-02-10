require 'rails_helper'

resource 'Projects' do
  explanation "Projects resource"

  header "Content-Type", "application/json"

  let!(:project) { create :project, title: 'title' }
  let(:id) { project.id }
  let(:last_project) { Project.last }

  get '/api/v1/projects' do
    context '200' do
      example 'Listing projects' do
        do_request

        expect(status).to eq 200
        expect(json_response_body.first).to be_a_project_representation(project)
      end
    end
  end

  post '/api/v1/projects' do
    let!(:number_of_projects) { Project.count }
    let(:number_of_projects_after_request) { Project.count }

    context '201' do
      let(:request) { { project: { title: 'Test title' } } }

      example 'Create project with correct data' do
        do_request(request)

        expect(status).to eq 201
        expect(json_response_body).to be_a_project_representation(last_project)
        expect(number_of_projects + 1).to eq(number_of_projects_after_request)
      end
    end

    context '400' do
      let(:request) { { project: { title: nil } } }

      example 'Create project with bad data' do
        do_request(request)

        expect(status).to eq 400
        expect(number_of_projects).to eq(number_of_projects_after_request)
      end
    end
  end

  get '/api/v1/projects/:id' do
    context '200' do
      example 'Get an project' do
        do_request

        expect(status).to eq(200)
        expect(json_response_body).to be_a_project_representation(project)
      end
    end
  end

  patch '/api/v1/projects/:id' do
    context '200' do
      let(:request) { { project: { title: 'Test title 2' } } }

      example 'Update project with correct data' do
        do_request(request)

        expect(status).to eq 200
        expect(project.reload.title).to eq('Test title 2')
      end
    end

    context '400' do
      let(:request) { { project: { title: nil } } }
      let!(:old_title) { project.title }

      example 'Update project with bad data' do
        do_request(request)

        expect(status).to eq 400
        expect(old_title).to eq(project.reload.title)
      end
    end
  end

  delete '/api/v1/projects/:id' do
    context '200' do
      example 'Destroy project' do
        do_request

        expect(status).to eq 200
        expect { project.reload }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
end
