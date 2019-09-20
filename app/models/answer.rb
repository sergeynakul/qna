class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward
  has_many :comments, dependent: :destroy, as: :commentable

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc) }

  after_create :subscribe_job

  def best!
    transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
      update!(reward: question.reward) if question.reward
    end
  end

  private

  def subscribe_job
    AnswerNotificationJob.perform_later(self)
  end
end
