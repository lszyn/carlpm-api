require 'rails_helper'

RSpec.describe 'tasks API' do

  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:tasks) { create_list(:task, 20, project_id: project.id) }
  let(:project_id) { project.id }
  let(:id) { tasks.first.id }
  let(:headers) { valid_headers }

  describe 'GET /v1/projects/:project_id/tasks' do
    before { get "/v1/projects/#{project_id}/tasks", headers: headers }

    context 'when project exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all project tasks' do
        expect(json.size).to eq(20)
      end
    end

    context 'when project does not exist' do
      let(:project_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  describe 'GET /v1/projects/:project_id/tasks/:id' do
    before { get "/v1/projects/#{project_id}/tasks/#{id}", headers: headers }

    context 'when project task exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the task' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when project task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  describe 'POST /v1/projects/:project_id/tasks' do
    let(:valid_attributes) { { name: 'Test Task', done: false, deadline: Date.current }.to_json }

    context 'when request attributes are valid' do
      before { post "/v1/projects/#{project_id}/tasks", params: valid_attributes, headers: headers }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/v1/projects/#{project_id}/tasks", params: { task: {name: ''}}.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PUT /v1/projects/:project_id/tasks/:id' do
    let(:valid_attributes) { { task: { name: 'Test Task' }}.to_json }

    before { put "/v1/projects/#{project_id}/tasks/#{id}", params: valid_attributes, headers: headers }

    context 'when task exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end

      it 'updates the task' do
        updated_item = Task.find(id)
        expect(updated_item.name).to match(/Test Task/)
      end
    end

    context 'when the task does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Task/)
      end
    end
  end

  describe 'DELETE /v1/projects/:id' do
    before { delete "/v1/projects/#{project_id}/tasks/#{id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
