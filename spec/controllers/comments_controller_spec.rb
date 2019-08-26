require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new comment in the database' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js }.to_not change(Comment, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
