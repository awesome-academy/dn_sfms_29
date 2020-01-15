class AdminController < ApplicationController
  before_action :check_logged_in, :check_user
  layout "admin/application"

  private

  def get_user_by pitch
    pitch.user_id
  end

  def check_pitch_owner pitch
    return unless check_owner?
    return if get_user_by(pitch) == current_user.id
  end
end
