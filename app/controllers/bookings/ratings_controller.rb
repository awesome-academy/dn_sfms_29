class Bookings::RatingsController < ApplicationController
  before_action :load_booking, :load_subpitch
  before_action :correct_user, only: %i(create update)
  before_action :load_rating, only: %i(edit update destroy)

  def new
    @rating = @booking.build_rating
    render :index
  end

  def create
    @rating = @booking.build_rating rating_params
    if @rating.save
      flash[:success] = t "msg.create_success"
      redirect_to bookings_path
    else
      flash.now[:danger] = t "msg.create_danger"
      render :index
    end
  end

  def edit
    respond_to do |format|
      format.html{render :index}
      format.js
    end
  end

  def update
    if @rating.update rating_params
      flash[:success] = t "msg.update_success"
      redirect_to bookings_path
    else
      flash[:danger] = t "msg.update_danger"
      redirect_to edit_booking_rating_path(@booking, @rating)
    end
  end

  def destroy
    if @rating.destroy
      flash[:success] = t "msg.destroy_success"
    else
      flash[:danger] = t "msg.destroy_danger"
    end
    redirect_to bookings_path
  end

  private

  def load_booking
    @booking = Booking.find_by id: params[:booking_id]
    return if @booking

    flash[:danger] = t "msg.danger_load_booking"
    redirect_to bookings_path
  end

  def load_subpitch
     @subpitch = @booking.subpitch
  end

  def correct_user
    @user = User.find_by id: params[:rating][:user_id]
    return if current_user?(@user) && @user

    flash[:danger] = t "msg.danger_permission"
    redirect_to bookings_path
  end

  def load_rating
    @rating = Rating.find_by id: params[:id]
    return if @rating

    flash[:danger] = t "msg.danger_load_rating"
    redirect_to bookings_path
  end

  def rating_params
    params.require(:rating).permit Rating::PARAMS
  end
end
