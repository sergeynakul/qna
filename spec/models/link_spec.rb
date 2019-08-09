require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validate url' do
    let(:question) { create :question }
    let!(:valid_link) { build(:link, url: 'http://google.com/', linkable: question) }
    let!(:invalid_link) { build(:link, url: 'googlecom', linkable: question) }

    it { expect(valid_link).to be_valid }
    it { expect(invalid_link).to be_invalid }

    it 'have message' do
      invalid_link.validate
      expect(invalid_link.errors[:url]).to include('is not a valid URL')
    end
  end
end
