require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
  let(:rewards_list) { create_list(:reward, 2, question: question, answer: answer, image: image) }

  describe 'GET #index' do
    before { login(user) }

    before { get :index, params: { user_id: user.id } }

    it 'populates an rewards' do
      expect(assigns(:rewards)).to eq rewards_list
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
