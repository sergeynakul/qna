require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards).through(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'check user is author of question' do
      expect(user).to be_author(question)
    end

    it 'check user is not author of question' do
      expect(other_user).to_not be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.subscribed_for?' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question)  { create(:question, user: user) }

    it 'subscribed to the question' do
      expect(user).to be_subscribed_for(question)
    end

    it 'not subscribed to the question' do
      expect(other_user).to_not be_subscribed_for(question)
    end
  end
end
