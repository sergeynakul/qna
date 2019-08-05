require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  describe 'Method best!' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answers) { create_list(:answer, 2, user: other_user, question: question) }
    let(:answer_first) { answers.first }
    let(:answer_last) { answers.last }

    it 'not the best' do
      expect(answer_first).to_not be_best
      expect(answer_last).to_not be_best
    end

    it 'set best answer' do
      expect { answer_last.best! }.to change(answer_last, :best).to(true)
    end

    context 'can be only one best answer on question' do
      before { answer_first.best! }

      it { expect(answer_first).to be_best }
      it { expect(answer_last).to_not be_best }
    end
  end
end
