require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:params) { { access_token: access_token.token } }
  let(:valid_params) { { question: attributes_for(:question), access_token: access_token.token } }
  let(:invalid_params) { { question: attributes_for(:question, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: params, headers: headers }

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'returns user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'returns short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body question_id user_id best created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:first_file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:second_file) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:question) { create(:question, files: [first_file, second_file]) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:resource_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: create(:user)) }
      let!(:links) { create_list(:link, 4, linkable: question) }

      before { get api_path, params: params, headers: headers }

      it_behaves_like 'API Lists' do
        let(:resource) { question }
      end

      it 'returns all public fields' do
        %w[id title body].each do |attr|
          expect(resource_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API create resource' do
      let(:resource) { Question }
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
    let(:method) { :put }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'with valid params update the question' do
        put api_path, params: valid_params, headers: headers

        question.reload

        %i[title body].each do |attr|
          expect(question.send(attr)).to eq valid_params[:question][attr]
        end
        expect(response).to be_successful
      end

      it 'with invalid params do not update the question' do
        put api_path, params: invalid_params, headers: headers

        question.reload

        %i[title body].each do |attr|
          expect(question.send(attr)).to_not eq invalid_params[:question][attr]
        end
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
    let(:method) { :delete }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'deletes the question' do
        expect { delete api_path, params: params, headers: headers }.to change(Question, :count).by(-1)
      end

      it 'returns success status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end
    end
  end
end
