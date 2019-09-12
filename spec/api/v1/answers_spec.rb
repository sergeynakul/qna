require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:question) { create(:question) }
  let(:access_token) { create(:access_token) }

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

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

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
    let(:valid_params) { { answer: attributes_for(:answer), access_token: access_token.token } }
    let(:invalid_params) { { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API create resource' do
      let(:resource) { Answer }
    end
  end
end
