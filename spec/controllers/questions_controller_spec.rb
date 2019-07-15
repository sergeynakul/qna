require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }
  let(:user) { create(:user) }

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new question in @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
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
end
