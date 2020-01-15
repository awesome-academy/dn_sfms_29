class LikeRating < ApplicationRecord
  belongs_to :rating
  belongs_to :user
end
