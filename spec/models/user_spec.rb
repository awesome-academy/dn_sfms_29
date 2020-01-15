require "rails_helper"

RSpec.describe User, type: :model do
  describe "Associations" do
    it "has many pitches" do
      association = described_class.reflect_on_association(:pitches)
      expect(association.macro).to eq :has_many
    end

    it "has many bookings" do
      association = described_class.reflect_on_association(:bookings)
      expect(association.macro).to eq :has_many
    end

    it "has many comments" do
      association = described_class.reflect_on_association(:comments)
      expect(association.macro).to eq :has_many
    end

    it "has many likes" do
      association = described_class.reflect_on_association(:likes)
      expect(association.macro).to eq :has_many
    end

    it "has many like_ratings" do
      association = described_class.reflect_on_association(:like_ratings)
      expect(association.macro).to eq :has_many
    end

    it "has many active_recharge" do
      association = described_class.reflect_on_association(:active_recharge)
      expect(association.macro).to eq :has_many
    end

    it "has many passive_recharge" do
      association = described_class.reflect_on_association(:passive_recharge)
      expect(association.macro).to eq :has_many
    end

    it {is_expected.to have_many(:receiver).through(:active_recharge)}
    it {is_expected.to have_many(:sender).through(:passive_recharge)}
  end

  describe "Validations" do
    it {is_expected.to validate_presence_of(:full_name)}
    it {is_expected.to validate_length_of(:full_name).is_at_most(50)}

    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to validate_length_of(:email).is_at_most(255)}

    it {is_expected.to allow_value(nil).for(:phone).on(:update)}
  end
end
