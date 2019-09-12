require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }
  let(:access_token) { create(:access_token) }
  let(:params) { { access_token: access_token.token } }
  let(:valid_params) { { answer: attributes_for(:answer), access_token: access_token.token } }
  let(:invalid_params) { { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/answers/:id' do
    let(:first_file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:second_file) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let(:answer) { create(:answer, files: [first_file, second_file], question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:resource_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before { get api_path, params: params, headers: headers }

      it_behaves_like 'API Lists' do
        let(:resource) { answer }
      end

      it 'returns all public fields' do
        %w[id body question_id].each do |attr|
          expect(resource_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API create resource' do
      let(:resource) { Answer }
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }
    let(:method) { :put }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'with valid params update the answer' do
        put api_path, params: valid_params, headers: headers

        answer.reload

        expect(answer.body).to eq valid_params[:answer][:body]
      end

      it 'with invalid params do not update the answer' do
        put api_path, params: invalid_params, headers: headers

        answer.reload

        expect(answer.body).to_not eq invalid_params[:answer][:body]
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'deletes the answer' do
        expect { delete api_path, params: params, headers: headers }.to change(Answer, :count).by(-1)
      end

      it 'returns success status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end
    end
  end
end
