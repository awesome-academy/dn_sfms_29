require "rails_helper"
require "support/spec_test_helper"

RSpec.configure do |c|
  c.include SpecTestHelper
end

RSpec.describe UsersController do
  render_views
  before(user: :is_admin) do
    login admin
  end
  before(user: :logged_in) do
    login user
  end
  let(:admin) do
    FactoryBot.create :user, role: 0, activated: true,
                      activated_at: Time.zone.now
  end
  let(:user) do
    FactoryBot.create :user, activated: true, activated_at: Time.zone.now
  end
  let(:get_show_with_valid_params){get :show, params: {id: user.id}}
  let(:get_show_with_invalid_params){get :show, params: {id: "invalid"}}
  let(:user_params){FactoryBot.attributes_for :user}
  let(:create_user_with_valid_params){post :create, params: {user: user_params}}
  let(:get_edit_with_valid_params) do
    get :edit, params: {id: user.id}
  end
  let(:path_update_with_valid_params) do
    patch :update, params: {user: user_params, id: user.id}
  end
  let(:patch_destroy_with_valid_params) do
    delete :destroy, params: {id: user.id}
  end

  describe "delete #destroy" do
    context "when not logged in" do
      it "redirect to login page" do
        patch_destroy_with_valid_params
        response.should redirect_to login_path
      end

      it "notify to flash danger" do
        path_update_with_valid_params
        flash[:danger].should eq I18n.t("users.please_log_in")
      end
    end

    context "when normal user", user: :logged_in do
      it "redirect to root page" do
        patch_destroy_with_valid_params
        response.should redirect_to root_path
      end

      it "not allow delete user" do
        expect{patch_destroy_with_valid_params}.to change(User, :count).by 0
      end
    end

    context "when user is admin", user: :is_admin do
      it "redirect to root page" do
        patch_destroy_with_valid_params
        response.should redirect_to admin_users_path
      end

      it "should delete one user" do
        user
        expect{patch_destroy_with_valid_params}.to change(User, :count).by -1
      end

      it "notify to flash danger" do
        patch_destroy_with_valid_params
        flash[:success].should eq I18n.t("msg.destroy_success")
      end
    end
  end

  describe "path #update" do
    context "when customer not logged in" do
      it "redirect to login page" do
        path_update_with_valid_params
        response.should redirect_to login_path
      end

      it "notify to flash danger" do
        path_update_with_valid_params
        flash[:danger].should eq I18n.t("users.please_log_in")
      end
    end

    context "when the user has logged in and valid params", user: :logged_in do
      it "return 200 status code" do
        path_update_with_valid_params
        response.should redirect_to user
      end

      it "should change user info" do
        path_update_with_valid_params
        User.find_by(id: user.id).full_name.should eq user_params[:full_name]
      end

      it "notify to flash[:success]" do
        path_update_with_valid_params
        flash[:success].should eq I18n.t("users.update.profile_updated")
      end
    end

    context "when the user has logged in and id param is not exist", user: :logged_in do
      it "redirect to root page" do
        patch :update, params: {user: user_params, id: "no_exist"}
        response.should redirect_to root_path
      end

      it "notify to flash[:danger]" do
        patch :update, params: {user: user_params, id: "no_exist"}
        flash[:danger].should eq I18n.t("users.id_unexist")
      end
    end

    context "when the user has logged in and id param is not user's one", user: :logged_in do
      it "redirect to root page" do
        user = FactoryBot.create :user
        patch :update, params: {user: user_params, id: user.id}
        response.should redirect_to root_path
      end

      it "notify to flash[:danger]" do
        user = FactoryBot.create :user
        patch :update, params: {user: user_params, id: user.id}
        flash[:danger].should eq I18n.t("users.not_allow")
      end
    end
  end

  describe "get #edit" do
    context "when customer not logged in" do
      it "redirect to login page" do
        get_edit_with_valid_params
        response.should redirect_to login_path
      end

      it "notify to flash danger" do
        get_edit_with_valid_params
        flash[:danger].should eq I18n.t("users.please_log_in")
      end
    end

    context "when the user has logged in and valid params", user: :logged_in do
      it "return 200 status code" do
        get_edit_with_valid_params
        response.should be_ok
      end

      it "contains content of edit page" do
        get_edit_with_valid_params
        response.body.should include I18n.t("helpers.submit.user.update")
      end
    end

    context "when the user has logged in and id param is not exist", user: :logged_in do
      it "redirect to root page" do
        get :edit, params: {id: "no_exist"}
        response.should redirect_to root_path
      end

      it "notify to flash[:danger]" do
        get :edit, params: {id: "no_exist"}
        flash[:danger].should eq I18n.t("users.id_unexist")
      end
    end

    context "when the user has logged in and id param is not user's one", user: :logged_in do
      it "redirect to root page" do
        user = FactoryBot.create :user
        get :edit, params: {id: user.id}
        response.should redirect_to root_path
      end

      it "notify to flash[:danger]" do
        user = FactoryBot.create :user
        get :edit, params: {id: user.id}
        flash[:danger].should eq I18n.t("users.not_allow")
      end
    end
  end

  describe "POST #create" do
    context "should fail with invalid params" do
      it "can't create any user" do
        visit new_user_path
        expect{click_button I18n.t("helpers.submit.user.create")}.to change(User, :count).by 0
      end

      it "return page with error activerecord" do
        visit new_user_path
        click_button I18n.t("helpers.submit.user.create")
        page.body.should include I18n.t("activerecord.errors.models.user.attributes.name.blank")
      end
    end

    context "when create successfully" do
      it "create new user" do
        visit new_user_path
        fill_in "user[full_name]", with: Faker::Name.name
        fill_in "user[email]", with: Faker::Internet.email
        fill_in "user[password]", with: Faker::String.random(length: 6..12)
        fill_in "user[password_confirmation]", with: find_field("user[password]").value
        expect{click_button I18n.t("helpers.submit.user.create")}.to change(User, :count).by 1
      end

      it "create one user with valid params" do
        expect {create_user_with_valid_params}.to change(User, :count).by 1
      end

      it "return root path" do
        create_user_with_valid_params
        expect(response).to redirect_to root_path
      end

      it "return flash success" do
        create_user_with_valid_params
        expect(flash[:info]).to match(I18n.t "users.create.please_check_mail")
      end
    end
  end

  describe "GET #show" do
    context "when the user has logged in and valid param", user: :logged_in do
      it "returns a 200 status code" do
        get_show_with_valid_params
        response.should have_http_status 200
      end

      it "contains content of view #show" do
        get_show_with_valid_params
        response.body.should include I18n.t("users.show.your_profile")
      end
    end

    context "when customer not logged in" do
      it "redirect to login" do
        get_show_with_valid_params
        response.should redirect_to login_path
      end
    end

    context "when has logged in but access other person profile", user: :logged_in do
      it "redirect to root" do
        get_show_with_invalid_params
        response.should redirect_to root_path
      end
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "returns a 200 status code respond" do
      response.should have_http_status 200
    end

    it "contains content of view #new" do
      response.body.should include I18n.t("helpers.submit.user.create")
    end
  end

  describe "GET #index" do
    before need: :users do
      @users = FactoryBot.create_list :user, 2
    end
    before {get :index}

    context "when user is admin", user: :is_admin do
      it "returns a 200 status code response" do
        response.should have_http_status 200
      end

      it "contains info users in body response", need: :users do
        @users.each do |user|
          response.body.should have_content user.full_name
        end
      end
    end

    context "when user has not been logged in yet" do
      it "redirects to login_path" do
        response.should redirect_to login_path
      end

      it "responds to html by default" do
        expect(response.content_type).to include "text/html"
      end
    end
  end
end
