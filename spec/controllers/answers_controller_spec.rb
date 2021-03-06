require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  include_examples 'voted controller'

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'created answer belongs to current_user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'author answer' do
      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author answer' do
      before { login(other_user) }

      it 'not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'status 302' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to eq 302
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'not changes answer attributes' do
        expect { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'user is author of question' do
      it 'can choose best answer' do
        patch :best, params: { id: answer }, format: :js
        expect(answer.reload).to be_best
      end

      it 'renders template best' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'user is not author of question' do
      before { login(other_user) }

      it 'can not choose best answer' do
        patch :best, params: { id: answer }, format: :js
        expect(answer.reload).to_not be_best
      end

      it 'status 302' do
        patch :best, params: { id: answer }, format: :js
        expect(response.status).to eq 302
      end
    end
  end
end
