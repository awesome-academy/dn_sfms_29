class BookingsController < ApplicationController
  before_action :logged_in_user, only: %i(create update)
  before_action :load_subpitch, only: %i(create new)
  before_action :load_schedule, :create_schedule_detail, only: :new
  before_action :load_booked_list, :verified_time, :check_error, only: :create
  before_action :load_user_in_booking, :correct_user, only: :update

  def index
    @bookings = current_user.bookings.search_name(params[:search])
                            .search_total(params[:search])
                            .paginate page: params[:page],
                             per_page: Settings.size.s10

  def new
    @bookings = current_user.bookings.recently if current_user
  end

  def create
    ActiveRecord::Base.transaction do
      @correct_params.each do |correct_param|
        @new_booking = current_user.bookings.build hash_params(correct_param)
        @new_booking.save!
      rescue StandardError
        flash[:danger] = t ".failed"
        raise ActiveRecord::Rollback
      end
      flash[:warning] = t ".success_booking"
    end
    redirect_to new_subpitch_booking_path(@subpitch)
  end

  def update
    if @booking.start_time > Time.zone.now
      ActiveRecord::Base.transaction do
        update_booking_and_user
        flash[:success] = t ".cancel_success"
      rescue StandardError
        flash[:danger] = t ".failed"
        raise ActiveRecord::Rollback
      end
    end
    redirect_to request.referer || root_path
  end

  private

  def check_error
    redirect_to new_subpitch_booking_path(@subpitch) if @error_flag
  end

  def update_booking_and_user
    @booking.cancel!
    @user.update! wallet: (@user.wallet + @booking.total_price)
  end

  def load_user_in_booking
    @booking = Booking.find_by id: params[:id]
    @user = @booking.user if @booking
    return if @booking

    flash[:danger] = t ".not_found"
    redirect_to request.referer || root_path
  end

  def create_schedule_detail
    @schedule_details = []
    if @booked_list.empty?
      @schedule_details = @schedules
      @schedule_details.each do |schedule_detail|
        if schedule_detail[0] < DateTime.now.strftime("%H:%M")
          schedule_detail[2] = Settings.past_time
        end
      end
      return
    end
    @booked_list.each do |book|
      next if out_schedule? book

      dispense book
    end
  end

  def dispense book
    @schedules.each_with_index do |schedule, index|
      next if @schedule_details[index] && @schedule_details[index][2] == true

      @period = @schedules[index]
      if schedule[0] < DateTime.now.strftime("%H:%M")
        @period[2] = Settings.past_time
      end
      @period[2] = true if conflict_schedule? book, schedule
      @schedule_details[index] = @period if allow_assign? index
    end
  end

  def allow_assign? index
    return true if !@schedule_details[index] || (!@schedule_details[index][2] &&
                   @period[2]) || (@schedule_details[index][2] ==
                   Settings.past_time && @period[2] == true)
  end

  def out_schedule? book
    return true if book.end_time.strftime("%H:%M") <= @start_time_schedule_hm ||
                   book.start_time.strftime("%H:%M") >= @end_time_schedule_hm
  end

  def conflict_schedule? book, schedule
    return true unless book.end_time.strftime("%H:%M") <= schedule[0] ||
                       schedule[1] <= book.start_time.strftime("%H:%M")
  end

  def hash_params arg
    {
      start_time: DateTime.strptime("#{arg.second} +07:00", "%H:%M %z"),
      end_time: DateTime.strptime("#{arg.second} +07:00", "%H:%M %z") +
        @limit.hour,
      subpitch_id: @subpitch.id,
      status: Settings.default_status_booking,
      total_price: @subpitch.price_per_hour * @limit
    }
  end

  def notice_blank_correct_param
    # loc ra nhung chuoi co dinh dang {00:00 - 23:59}
    @correct_params = booking_params.select do |_, time|
      time =~ /^(0[0-9]|1[0-9]|2[0-3]|[0-9]):([0-9]|[0-5][0-9])$/
    end
    return if @correct_params.present?

    flash[:danger] = t ".not_choose_or_invalid_time"
    @error_flag = true
  end

  def normalize_time arg
    @period = DateTime.strptime("#{arg.second} +07:00", "%H:%M %z")
  end

  def cant_be_in_past_time
    # khong duoc book thoi gian o qua khu
    return if @error_flag

    return if @period >= DateTime.now

    flash[:danger] = t ".time_has_passed"
    @error_flag = true
  end

  def in_pitch_schedule
    return if @error_flag

    # moc thoi gian phai nam trong lich trinh
    return if (@period.strftime("%H:%M") >= @start_time_schedule_hm) &&
              ((@period + @limit.hour).strftime("%H:%M") <=
              @end_time_schedule_hm)

    flash[:danger] = t ".time off schedule"
    @error_flag = true
  end

  def in_cycle_time
    return if @error_flag

    return if @period.min == @start_time_schedule.min

    flash[:danger] = t ".wrong_cycle_time"
    @error_flag = true
  end

  def check_conflict_booking
    return if @error_flag

    return if @booked_list.empty?

    @booked_list.each do |booked|
      # kiem tra moc thoi gian khong trung voi lich da book
      next unless (booked.start_time <= @period && @period < booked.end_time) ||
                  (booked.start_time < @period + @limit.hour &&
                  @period + @limit.hour <= booked.end_time)

      flash[:danger] = t ".time has been taken"
      @error_flag = true
      break
    end
  end

  def check_match_in_database
    return if @error_flag

    @correct_params.each do |param|
      normalize_time param
      cant_be_in_past_time
      in_pitch_schedule
      in_cycle_time
      check_conflict_booking
    end
  end

  def verified_time
    @error_flag = false
    notice_blank_correct_param
    check_match_in_database
  end

  def load_subpitch
    params[:subpitch_id] ||= params[:booking][:subpitch_id]
    @subpitch = Subpitch.find_by id: params[:subpitch_id]
    return if @subpitch

    flash[:danger] = t ".not_found_subpitch_id"
    redirect_to root_path
  end

  def load_subpitch_info
    @pitch = @subpitch.pitch
    @limit = @pitch.limit
    @limit_second = @pitch.limit * 3600
    @start_time_schedule = @pitch.start_time
    @end_time_schedule = @pitch.end_time
    @start_time_schedule_hm = @start_time_schedule.strftime("%H:%M")
    @end_time_schedule_hm = @end_time_schedule.strftime("%H:%M")
  end

  def load_booked_list
    load_subpitch_info
    @booked_list = @subpitch.bookings.today.verifiled_paid
  end

  def declare_schedules
    len = ((@end_time_schedule - @start_time_schedule) / @limit_second).to_int
    @schedules = Array.new
    (0..(len - 1)).each do |i|
      start_time = (@start_time_schedule + (i * @limit).hour).strftime("%H:%M")
      end_time =
        (@start_time_schedule + ((i + 1) * @limit).hour).strftime("%H:%M")
      period = [start_time, end_time]
      @schedules << period
    end
  end

  def load_schedule
    load_booked_list
    declare_schedules
  end

  def booking_params
    params.require :booking
  end
end
