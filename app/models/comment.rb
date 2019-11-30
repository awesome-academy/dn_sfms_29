class Comment < ApplicationRecord
  ALLOW_PARAMS = %i(content rating_id).freeze
  belongs_to :user
  validates :rating_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.comment_length_max}
  delegate :full_name, to: :user, prefix: true
  scope :by_rating, ->(rating){where rating_id: rating.id}
end
