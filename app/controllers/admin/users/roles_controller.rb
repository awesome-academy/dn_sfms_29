class Admin::Users::RolesController < UsersController
  before_action :load_user

  def create
    if @user.update role: params[:user][:role].to_i
      flash[:success] = t "msg.update_success"
    else
      flash[:danger] = t "msg.update_success"
    end
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user && !current_user?(@user)

    flash[:danger] = t "msg.danger_load"
    redirect_to admin_users_path
  end

  def role_params
    params.require(:user).permit :role
  end
end
