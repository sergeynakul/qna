require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create :question }
  let(:answer) { create :answer }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'redirects to new' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
