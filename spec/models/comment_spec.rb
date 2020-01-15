require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "Associations" do
    it "belongs to user" do
      should belong_to :user
    end

    it "belongs to rating" do
      should belong_to :rating
    end
  end

  describe "Validates" do
    it {should validate_presence_of(:rating_id)}

    it {should validate_presence_of(:content)}
    it {should validate_length_of(:content).is_at_most(150)}
  end
end
