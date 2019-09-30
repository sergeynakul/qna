require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).touch(true) }

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

  describe 'Link#gist?' do
    let(:question) { create :question }
    let!(:google_link) { build(:link, url: 'http://google.com/', linkable: question) }
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38', linkable: question) }

    it { expect(google_link).to_not be_gist }
    it { expect(gist_link).to be_gist }
  end

  describe 'Link#gist' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38') }

    it { expect(gist_link.gist).to be_a_kind_of Array }
    it { expect(gist_link.gist.first).to include(name: 'SQL запросы') }
  end
end
