require 'rails_helper'

RSpec.describe 'Projects API V!', type: :request do
  let(:user) { create(:user) }

  let!(:projects) { create_list(:project, 10, user: user) }
  let(:project_id) { projects.first.id }

  let(:headers) { valid_headers }

  describe 'GET /v1/projects' do
    before { get '/v1/projects', headers: headers }

    it 'returns projects' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /projects/:id' do
    before { get "/v1/projects/#{project_id}", headers: headers }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(project_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:project_id) { 123 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Project/)
      end
    end
  end

  describe 'POST /v1/projects' do
    # valid payload
    let(:valid_attributes) { { project: { title: 'Finish Carl Code Challenge' } }.to_json }

    context 'when the request is valid' do
      before { post '/v1/projects', params: valid_attributes, headers: headers }

      it 'creates a todo' do
        expect(json['title']).to eq('Finish Carl Code Challenge')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/v1/projects', params: { project: {title: ''} }.to_json, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe 'PUT /v1/projects/:id' do
    let(:valid_attributes) { { project: { title: 'Test Project' } }.to_json }

    context 'when the record exists' do
      before { put "/v1/projects/#{project_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(json['title']).to eq('Test Project')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /v1/projects/:id' do
    before { delete "/v1/projects/#{project_id}", headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
