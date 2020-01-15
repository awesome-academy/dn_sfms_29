require "rails_helper"

RSpec.describe LikeRating, type: :model do
  describe "Associations" do
    it "belong to rating" do
      should belong_to :rating
    end

    it "belong to user" do
      should belong_to :user
    end
  end
end
