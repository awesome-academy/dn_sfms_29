require "rails_helper"

RSpec.describe Recharge, type: :model do
  describe "Associations" do
    it "belongs to sender" do
      should belong_to(:sender).class_name(User.name)
    end

    it "belongs to receiver" do
      should belong_to(:receiver).class_name(User.name)
    end
  end

  describe "Validates" do
    it {is_expected.to validate_presence_of(:sender_id)}
    it {is_expected.to validate_presence_of(:receiver_id)}

    it {should validate_numericality_of(:money)}

    it "money should > 0" do
      recharge = create :recharge
      recharge.valid?
    end
  end

  describe "Scopes" do
  end
end
