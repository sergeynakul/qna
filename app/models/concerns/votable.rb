module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.sum(:value)
  end

  def vote_up(user)
    vote = Vote.find_or_initialize_by(user: user, votable: self)
    vote.value += 1
    destroy_if_revote(vote)
  end

  def vote_down(user)
    vote = Vote.find_or_initialize_by(user: user, votable: self)
    vote.value -= 1
    destroy_if_revote(vote)
  end

  def destroy_if_revote(vote)
    return vote unless vote.value.zero?

    vote.destroy
    nil
  end
end
