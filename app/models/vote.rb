class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  def self.vote_up(user, votable)
    vote = Vote.where(user: user, votable: votable).find_or_initialize_by(user: user, votable: votable)
    vote.value += 1
    destroy_if_revote(vote)
  end

  def self.destroy_if_revote(vote)
    return vote unless vote.value.zero?
    vote.destroy
    nil
  end
end
