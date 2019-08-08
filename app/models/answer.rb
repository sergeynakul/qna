class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def best!
    transaction do
      Answer.where(question_id: question_id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end
