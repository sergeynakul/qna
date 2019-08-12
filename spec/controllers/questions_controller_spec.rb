require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create(:user) }
  let(:question) { create :question }

  before { login(user) }

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns a new answer in @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link in @link' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new question in @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns a new link in @link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new reward in @reward' do
      expect(assigns(:question).reward).to be_a_new(Reward)
    end

    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'created question belongs to current_user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'redirects to new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, user: user) }

    context 'with valid attributes' do
      it 'assigns requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'not changes question attributes' do
        expect { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }.to_not change(question, :title)
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'user is not author of question' do
      before { login(other_user) }

      it 'can not change question' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'author question' do
      it 'delete the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'not author question' do
      before { login(other_user) }

      it 'not delete the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
