require "rails_helper"

RSpec.describe Like, type: :model do
  describe "Associations" do
    it "belongs to user" do
      should belong_to :user
    end

    it "belongs to subpitch" do
      should belong_to :subpitch
    end
  end
end
