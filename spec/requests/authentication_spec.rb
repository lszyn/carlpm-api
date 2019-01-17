require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /v1/auth/login' do
    let!(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) do
      {user: {
        email: user.email,
        password: user.password
      }}.to_json
    end
    let(:invalid_credentials) do
      { user:
          {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
      }.to_json
    end
    context 'When request is valid' do
      before { post '/v1/auth/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['token']).not_to be_nil
      end
    end

    # returns failure message when request is invalid
    context 'When request is invalid' do
      before { post '/v1/auth/login', params: invalid_credentials, headers: headers }

      it 'returns a failure message' do
        expect(json['message']).to match(/Invalid credentials/)
      end
    end
  end
end
