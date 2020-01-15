require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let!(:valid_session) {{}}
  describe "GET #index" do
    context "with admin" do
      login_admin

      it "should have status 200" do
        get :index, params: {}, session: valid_session
        expect(response.status).to eq(200)
      end

      it "render index" do
        get :index, params: {}, session: valid_session
        expect(response).to render_template :index
      end
    end

    context "with user" do
      login_user
      it "response status 302" do
        get :index, params: {}, session: valid_session
        expect(response.status).to eq(302)
      end

      it "redirect to root_path" do
        get :index, params: {}, session: valid_session
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET #show" do
    let!(:user){FactoryBot.create(:user)}
    context "with valid user" do
      login_user

      it "return status 200" do
        get :show, params: {id: user.to_param}, session: valid_session
        expect(response.status).to eq(200)
      end

      it "render show" do
        get :show, params: {id: user.to_param}, session: valid_session
        expect(response).to render_template :show
      end
    end

    context "with admin" do
      login_admin
      it "render template admin" do
        get :show, params: {id: user.to_param}, session: valid_session
        expect(response.status).to render_template("layouts/admin/application")
      end
    end

    context "with invalid" do
      it "redirect to signin" do
        get :show, params: {id: user.to_param}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user){create :user}
    context "with admin" do
      login_admin
      it "destroy success" do
        expect{delete :destroy, params: {id: user.to_param}}.to change(User,:count).by(-1)
      end

      it "destroy danger" do
        delete :destroy, params: {id: 100000}
        expect(flash[:danger]).to be_present
      end
    end

    context "with user" do
      login_user
      it "redirect to root_path" do
        delete :destroy, params: {id: user.to_param}
        expect(response).to redirect_to root_path
      end
    end

    context "with invalid user" do
      it "redirect to sign in" do
        delete :destroy, params: {id: user.to_param}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
