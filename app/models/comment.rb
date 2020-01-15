class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :rating

  validates :rating_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.comment_length_max}
end
