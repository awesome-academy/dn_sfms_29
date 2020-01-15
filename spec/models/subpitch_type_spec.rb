require "rails_helper"

RSpec.describe SubpitchType, type: :model do
  describe "Associations" do
    it "should has many subpitch" do
      should have_many :subpitches
    end
  end

  describe "Validates" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_length_of(:name).is_at_most(50)}

    it {is_expected.to validate_length_of(:description).is_at_most(255)}
  end
end
