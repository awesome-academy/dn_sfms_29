require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper do
  describe "#full_title" do
    it "return the default title" do
      expect(helper.full_title).to eq("soccer fields")
    end

    it "return title follow argument" do
      expect(helper.full_title("hello")).to eq("hello | soccer fields")
    end
  end

  describe "#gender" do
    it "return male" do
      expect(helper.gender(0)).to eq("Male")
    end

    it "return female" do
      expect(helper.gender(1)).to eq("Female")
    end
  end
end
