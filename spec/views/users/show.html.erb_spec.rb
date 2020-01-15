require "rails_helper"
include ControllerMacros

describe "users/show.html.erb" do
  login_admin
  it "display user details correctly" do
    @user = create :user
    render

    assert_select "div[id=?]", "home" do
      assert_select "div", "#{@user.email}"
      assert_select "div", "#{@user.full_name}"
    end
  end
end
