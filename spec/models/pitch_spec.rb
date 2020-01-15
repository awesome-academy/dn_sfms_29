require "rails_helper"

RSpec.describe Pitch, type: :model do
  describe "Associations" do
    it "belongs to user" do
      should belong_to(:user)
    end

    it "should to subpitches" do
      should have_many(:subpitches)
    end

    it "should to bookings" do
      should have_many(:bookings).through(:subpitches)
    end
  end

  describe "Validates" do
    it {should validate_presence_of(:name)}
    it {should validate_length_of(:name).is_at_most(50)}

    it {should validate_length_of(:description).is_at_most(255)}

    it {should validate_presence_of(:country)}
    it {should validate_length_of(:country).is_at_most(50)}

    it {should validate_presence_of(:city)}
    it {should validate_length_of(:city).is_at_most(50)}

    it {should validate_presence_of(:district)}
    it {should validate_length_of(:district).is_at_most(50)}

    it {should validate_presence_of(:address)}
    it {should validate_length_of(:address).is_at_most(100)}

    it {should validate_presence_of(:phone)}
    it {should validate_length_of(:phone).is_at_least(6).is_at_most(12)}
    it {should validate_numericality_of(:phone)}

    it "should end_time > start_time and should play_time > limit" do
      pitch = build :pitch
      pitch.valid?
    end
  end
end
