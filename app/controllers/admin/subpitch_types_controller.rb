class Admin::SubpitchTypesController < AdminController
  before_action :check_admin
  before_action :load_subpitch_type, except: %i(index new create)

  def index
    @subpitch_types = SubpitchType.search(params[:search])
                                  .paginate page: params[:page],
                                   per_page: Settings.size.s10
  end

  def show; end

  def new
    @subpitch_type = SubpitchType.new
  end

  def create
    @subpitch_type = SubpitchType.new subpitch_type_params
    if @subpitch_type.save
      flash[:success] = t "msg.create_success"
      redirect_to admin_subpitch_type_path(@subpitch_type)
    else
      flash.now[:danger] = t "msg.create_danger"
      render :new
    end
  end

  def destroy
    if @subpitch_type.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to admin_subpitch_types_path
  end

  def edit; end

  def update
    if @subpitch_type.update subpitch_type_params
      flash[:success] = t "msg.update_success"
      redirect_to admin_subpitch_type_path(@subpitch_type)
    else
      flash.now[:danger] = t "msg.update_danger"
      render :edit
    end
  end

  private

  def subpitch_type_params
    params.require(:subpitch_type).permit SubpitchType::TYPE
  end

  def load_subpitch_type
    @subpitch_type = SubpitchType.find_by id: params[:id]
    return if @subpitch_type

    flash[:danger] = t "msg.danger_load"
    redirect_to subpitch_types_path
  end
end
