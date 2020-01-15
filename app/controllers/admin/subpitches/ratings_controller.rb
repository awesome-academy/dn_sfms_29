class Admin::Subpitches::RatingsController < AdminController
  before_action :load_rating, :check_account_permission, only: :destroy
  before_action :load_rating_index, only: :index

  def index; end

  def destroy
    if @rating.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to admin_ratings_path
  end

  private

  def load_subpitch
    @subpitch = Subpitch.find_by id: params[:subpitch_id]
    return if @subpitch

    flash[:danger] = t "msg.danger_load"
    redirect_to admin_ratings_path
  end

  def check_account_permission
    return if check_admin?

    return if @rating.booking.subpitch.pitch.user_id == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_ratings_path
  end

  def load_rating
    @rating = Rating.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "msg.danger_load"
    redirect_to admin_ratings_path
  end

  def load_rating_index
    @ratings = check_owner? ? Rating.by_owner(current_user.id) : Rating
    @ratings = @ratings.includes(booking: :subpitch).search(params[:search])
                       .newest.paginate page: params[:page],
                        per_page: Settings.size.s10
  end
end
