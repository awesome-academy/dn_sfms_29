require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "Associations" do
    it "belongs to subpitch" do
      should belong_to :subpitch
    end

    it "has one rating" do
      should have_one :rating
    end
  end

  describe "Validates" do
    it {should validate_presence_of(:start_time)}
    it {should validate_presence_of(:end_time)}
    it {should validate_presence_of(:subpitch_id)}
    it {should validate_presence_of(:total_price)}

    context "custom validates" do
      let!(:booking){FactoryBot.create(:booking)}
      it "check status and exist" do
        booking.status = 0
        booking.save! context: :payment
        expect(booking).to have(0).errors
      end
    end
  end
end
