require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#full_title" do
    it "return expect title with blank params" do
      expect(helper.full_title nil).to eq I18n.t "generate.page_title"
    end

    it "return expect title with present params" do
      expect(helper.full_title "abc").to eq("abc|" << I18n.t("generate.page_title"))
    end
  end
end
