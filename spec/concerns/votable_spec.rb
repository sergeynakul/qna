require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:model_klass) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(model_klass) }
  let(:owned_votable) { create(model_klass, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:votes_up) { create_list(:vote, 10, user: create(:user), votable: votable, value: 1) }
    let!(:votes_down) { create_list(:vote, 3, user: create(:user), votable: votable, value: -1) }

    it { expect(votable.rating).to eq 7 }
  end

  describe '#vote_up' do
    it { expect(votable.vote_up(user)).to be_an_instance_of(Vote) }

    it 'return nil if revote' do
      create(:vote, user: user, votable: votable, value: -1)
      expect(votable.vote_up(user)).to be_nil
    end

    context 'someone elses votable' do
      it { expect { votable.vote_up(user).save }.to change(votable, :rating).by(1) }

      it 'already have vote' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { votable.vote_up(user).save }.to change(votable, :rating).by(1)
      end
    end
  end

  describe '#vote_down' do
    it { expect(votable.vote_down(user)).to be_an_instance_of(Vote) }

    it 'return nil if revote' do
      create(:vote, user: user, votable: votable, value: 1)
      expect(votable.vote_down(user)).to be_nil
    end

    context 'someone elses votable' do
      it { expect { votable.vote_down(user).save }.to change(votable, :rating).by(-1) }

      it 'already have vote down' do
        create(:vote, user: create(:user), votable: votable, value: 1)
        expect { votable.vote_down(user).save }.to change(votable, :rating).by(-1)
      end
    end
  end
end
