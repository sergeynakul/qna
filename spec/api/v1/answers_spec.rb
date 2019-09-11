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
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: create(:user)) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of files' do
        expect(answer_response['files'].size).to eq 2
      end

      it 'returns list of comments' do
        expect(answer_response['comments'].size).to eq 3
      end

      it 'returns list of links' do
        expect(answer_response['links'].size).to eq 4
      end

      it 'returns all public fields' do
        %w[id body question_id].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
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

    context 'authorized' do

      it 'with valid params create the answer' do
        expect { post api_path, params: valid_params, headers: headers }.to change(Answer, :count).by(1)
      end

      it "with invalid params doesn't create the answer" do
        expect { post api_path, params: invalid_params, headers: headers }.to_not change(Answer, :count)
      end
    end
  end
end
