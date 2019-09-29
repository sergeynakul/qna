require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable model'

  it { should belong_to(:question).touch(true) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of(:body) }

  it { should accept_nested_attributes_for :links }

  describe 'Answer#best!' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 2, user: other_user, question: question) }
    let!(:answer_first) { answers.first }
    let!(:answer_last) { answers.last }
    let(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
    let!(:reward) { create(:reward, question: question, image: image) }

    it 'not the best' do
      expect(answer_first).to_not be_best
      expect(answer_last).to_not be_best
    end

    it 'set best answer' do
      expect { answer_last.best! }.to change(answer_last, :best).to(true)
    end

    it 'add reward to user' do
      expect { answer_first.best! }.to change(other_user.rewards, :count).by(1)
    end

    context 'can be only one best answer on question' do
      before { answer_first.best! }

      it { expect(answer_first).to be_best }
      it { expect(answer_last).to_not be_best }
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  let(:answer) { build(:answer) }

  it 'perform answer notification job' do
    expect(AnswerNotificationJob).to receive(:perform_later).with(answer)
    answer.save
  end
end
