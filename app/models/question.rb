class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscribers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :user
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :author_subscription

  private

  def author_subscription
    subscribers.create!(user: user)
  end
end
