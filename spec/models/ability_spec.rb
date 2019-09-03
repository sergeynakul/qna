require 'rails_helper'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:user_question) { create(:question, user: user, files: [file]) }
    let(:other_user_question) { create(:question, user: other, files: [file]) }
    let(:user_answer) { create(:question, user: user, files: [file]) }
    let(:other_user_answer) { create(:question, user: other, files: [file]) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, user_question }
    it { should_not be_able_to :update, other_user_question }
    it { should be_able_to :update, user_answer }
    it { should_not be_able_to :update, other_user_answer }

    it { should be_able_to :destroy, user_question }
    it { should_not be_able_to :destroy, other_user_question }
    it { should be_able_to :destroy, user_answer }
    it { should_not be_able_to :destroy, other_user_answer }

    it { should be_able_to :best, create(:answer, user: other, question: user_question) }
    it { should_not be_able_to :best, create(:answer, user: user, question: other_user_question) }

    it { should be_able_to :destroy, user_question.files.first }
    it { should_not be_able_to :destroy, other_user_question.files.first }
    it { should be_able_to :destroy, user_answer.files.first }
    it { should_not be_able_to :destroy, other_user_answer.files.first }

    it { should be_able_to :index, Reward }

    it { should be_able_to :vote_up, other_user_question }
    it { should be_able_to :vote_up, other_user_answer }
    it { should be_able_to :vote_down, other_user_question }
    it { should be_able_to :vote_down, other_user_answer }

    it { should_not be_able_to :vote_up, user_question }
    it { should_not be_able_to :vote_up, user_answer }
    it { should_not be_able_to :vote_down, user_question }
    it { should_not be_able_to :vote_down, user_answer }
  end
end
