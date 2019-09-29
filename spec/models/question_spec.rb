require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  it_behaves_like 'votable model'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:subscribers).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'author subscribes by default' do
    expect(question.subscribers.first.user).to eq question.user
  end

  describe 'default scope' do
    let!(:first_question) { create(:question) }
    let!(:second_question) { create(:question) }

    it 'orders by asc' do
      first_question.update(title: 'new title')
      expect(Question.all).to eq [first_question, second_question]
    end
  end
end
