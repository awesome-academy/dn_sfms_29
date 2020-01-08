class BookingsController < ApplicationController
  before_action :check_logged_in

  def index
    @bookings = current_user.bookings.search_name(params[:search])
                            .search_total(params[:search])
                            .paginate page: params[:page],
                             per_page: Settings.size.s10
  end
end
