module UsersHelper
  private

  def role
    [{id: 0, name: ".admin"}, {id: 1, name: ".owner"}, {id: 2, name: ".user"}]
  end

  def check_admin?
    current_user.admin?
  end

  def check_owner?
    current_user.owner?
  end

  def check_admin
    return if current_user.admin?

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_root_path
  end

  def check_user
    return unless current_user.user?

    redirect_to root_path
    flash[:danger] = t "admin.danger_permission"
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".id_unexist"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t ".not_allow"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_path
  end
end
