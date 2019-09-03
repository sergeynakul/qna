require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'authenticated user' do
      before { login(user) }

      context 'author' do
        let!(:resource) { create(:question, user: user, files: [file]) }

        it 'should remove attached file' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to change(resource.files, :count).by(-1)
        end

        it 'should render destroy' do
          delete :destroy, params: { id: resource.files.first }, format: :js

          expect(response).to render_template :destroy
        end
      end

      context 'not author' do
        let!(:resource) { create(:question, user: other_user, files: [file]) }

        it 'should not remove attached file' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
        end

        it 'status 302' do
          delete :destroy, params: { id: resource.files.first }, format: :js

          expect(response.status).to eq 302
        end
      end
    end

    context 'unauthenticated user' do
      let!(:resource) { create(:question, user: user, files: [file]) }

      it 'should not remove attached file' do
        expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
      end

      it 'should render status 401' do
        delete :destroy, params: { id: resource.files.first }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
