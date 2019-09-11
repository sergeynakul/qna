class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id
  has_many :comments, as: :commentable
  has_many :links, as: :linkable
  has_many :files
end
