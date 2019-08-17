require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_inclusion_of(:value).in_array([-1, 1]).with_message("You can't vote twice") }

  describe 'author_cant_vote' do
    let(:user) { create(:user) }
    let(:votable) { create(:answer, user: user) }

    it { expect { votable.vote_up(user).save }.to_not change(votable, :rating) }

    it 'have error message' do
      vote = votable.vote_up(user)
      vote.valid?
      expect(vote.errors[:user]).to include("Author can't vote")
    end
  end
end
