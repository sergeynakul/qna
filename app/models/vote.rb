class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, inclusion: { in: [-1, 1], message: "You can't vote twice" }
  validate :author_cant_vote

  private

  def author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author?(votable)
  end
end
