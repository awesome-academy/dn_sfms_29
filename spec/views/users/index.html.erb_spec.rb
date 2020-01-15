require "rails_helper"
include ControllerMacros

describe "users/index.html.erb" do
  context "with 2 users" do
    login_admin
    before(:each) do
      create_list(:user, 2)
      @users = assign(:users, User.all)
      assign(:search, User.ransack(params: {q: {full_name_or_email_cont: ""}}))
      allow(view).to receive_messages(will_paginate: nil)
      render
    end

    it "display both users" do
      expect(response).to render_template(partial: "_user")
      assert_select "table" do
        assert "tr" do
          assert_select "td", "#{@users.first.email}"
          assert_select "td", "#{@users.first.full_name}"
          assert_select "a[href=?]", "/users/#{@users.first.id}"
          assert_select "a[data-method=delete]", count: 2
        end

        assert "tr" do
          assert_select "td", "#{@users.second.email}"
          assert_select "td", "#{@users.second.full_name}"
          assert_select "a[href=?]", "/users/#{@users.second.id}"
          assert_select "a[data-method=delete]", count: 2
        end
      end
    end

    it "should have form search" do
      assert_select "form[action=?]", "/admin/users" do
        assert_select "input[name=?]", "q[full_name_or_email_cont]"
        assert_select "button[type=?]", "submit"
      end
    end
  end
end
