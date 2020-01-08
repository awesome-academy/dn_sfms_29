module Bookings::RatingsHelper
  def show_rating star, status = false
    html = ""
    Settings.size.s5.times do |n|
      attribute = get_attribute(star, status, n)
      if star && star > 0
        html += render partial: "button_evaluated",
                locals: {attribute: attribute}
        star -= 1
      else
        html += render partial: "button_evaluate",
                locals: {attribute: attribute}
      end
    end
    html
  end

  def get_attribute star, status, n
    if star && star > 0
      attribute = "onclick=chose_star(this.id) value=1 id=star_#{n+1}"
    else
      if status
        attribute = "onclick=chose_star(this.id) value=0 id=star_#{n+1}"
      else
        attribute = nil
      end
    end
  end
end
