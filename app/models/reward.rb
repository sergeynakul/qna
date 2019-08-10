class Reward < ApplicationRecord
  has_one_attached :image
  belongs_to :question
  belongs_to :answer, optional: true

  validates :name, presence: true
end
