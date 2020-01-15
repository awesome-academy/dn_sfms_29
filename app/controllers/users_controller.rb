require "open-uri"
class UsersController < ApplicationController
  layout :load_layout
  before_action :load_user, except: %i(index new create)
  before_action :authenticate_user!, only: %i(index destroy show)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy index)

  def index
    @search = User.ransack params[:q]
    @users = @search.result.order_confirm
                 .paginate page: params[:page], per_page: Settings.size.s10
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to admin_users_path
  end

  private

  def admin_user
    authorize! :read, current_user
  end

  def load_layout
    request.original_url.include?("admin") ? "admin/application" : "application"
  end
end
