class RegistrationsController < Devise::RegistrationsController
  layout :load_layout
  before_action :get_path, only: %i(create update)

  def create
    @user = User.new user_params
    super
  end

  def update
    @user.update user_params_update
    super
  end

  private

  def user_params
    params.require(:user).permit User::DATA_TYPE_USERS
  end

  def user_params_update
    params.require(:user).permit User::DATA_TYPE_UPDATE_PROFILE
  end

  def get_path
    request.referer.include?("admin") ? "admin_" : ""
  end

  def load_layout
    request.original_url.include?("admin") ? "admin/application" : "application"
  end
end
