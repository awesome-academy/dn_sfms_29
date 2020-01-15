require "rails_helper"

RSpec.describe Rating, type: :model do
  describe "Associations" do
    it "belongs to user" do
      should belong_to :user
    end

    it "belongs to booking" do
      should belong_to :booking
    end

    it "has many comments" do
      should have_many :comments
    end
  end

  describe "Validates" do
    it {should validate_presence_of(:content)}
    it {should validate_length_of(:content).is_at_least(10)}

    it {should validate_presence_of(:star)}
    it {should validate_numericality_of(:star)}
    it {should allow_value(5).for(:star)}
  end

  describe "Delegate" do
    it {should delegate_method(:full_name).to(:user).with_prefix(true)}

    it {should delegate_method(:status).to(:booking).with_prefix(true)}
    it {should delegate_method(:total_price).to(:booking).with_prefix(true)}
  end
end
