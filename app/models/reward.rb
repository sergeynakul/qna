class Reward < ApplicationRecord
  has_one_attached :image
  belongs_to :question
  belongs_to :answer, optional: true

  validates :name, presence: true
  validate :attached_image

  private

  def attached_image
    errors.add(:image, 'is not attached') unless image.attached?
    errors.add(:image, 'has wrong file type') unless image.attached? && image.content_type =~ /^image/
  end
end
