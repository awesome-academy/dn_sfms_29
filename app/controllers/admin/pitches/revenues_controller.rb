class Admin::Pitches::RevenuesController < AdminController
  before_action :load_pitch, only: :show
  before_action :load_revenue, only: :index
  before_action ->{check_pitch_owner(@pitch)}, only: :show

  def index; end

  def show
    @revenue_details = Subpitch.search(params[:search]).revenue_subpitch(@pitch)
                               .paginate page: params[:page],
                                per_page: Settings.size.s10
  end

  private

  def load_revenue
    @revenues = check_owner? ? current_user.pitches : Pitch
    @revenues = @revenues.revenue_pitch.search_pitch(params[:search])
                         .order_pitch(params[:order]).active_booking
                         .month_revenue(@month)
                         .paginate page: params[:page],
                          per_page: Settings.size.s10
  end

  def load_pitch
    @pitch = Pitch.find_by id: params[:id]
    return if @pitch

    flash[:danger] = t "msg.danger_load"
    redirect_to revenue_admin_pitches_path
  end
end
