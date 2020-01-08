module BookingsHelper
  def get_path_form booking
    return booking_ratings_path(booking) unless booking.rating.id

    booking_rating_path(booking, booking.rating.id)
  end
end
