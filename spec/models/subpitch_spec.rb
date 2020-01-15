require "rails_helper"

RSpec.describe Subpitch, type: :model do
  describe "Associations" do
    it "has many bookings" do
      should have_many :bookings
    end

    it "has many ratings" do
      should have_many :ratings
    end

    it "has many comments" do
      should have_many :comments
    end

    it "has many likes" do
      should have_many :likes
    end

    it "belongs to pitch" do
      should belong_to :pitch
    end

    it "belong to subpitch_type" do
      should belong_to :subpitch_type
    end
  end

  describe "Delegate" do
    it {should delegate_method(:name).to(:pitch).with_prefix(true)}
    it {should delegate_method(:name).to(:subpitch_type).with_prefix(true)}
  end

  describe "Validates" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_length_of(:name).is_at_most(50)}

    it {is_expected.to validate_length_of(:description).is_at_most(255)}

    it {is_expected.to validate_presence_of(:price_per_hour)}
    it {should validate_numericality_of(:price_per_hour)}

    it {is_expected.to validate_presence_of(:size)}
    it {is_expected.to validate_length_of(:size).is_at_most(50)}
  end

  describe "Scopes" do
  end
end
