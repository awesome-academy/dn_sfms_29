class CommentsController < ApplicationController
  before_action :logged_in_user, :load_comment, :load_author_comment,
                :correct_user, :check_creator, only: %i(update destroy)

  def create
    preprocess_and_save
    respond_to do |format|
      if !@fail
        format.js{@success = t ".comment_success"}
      else
        format.js{@fail}
      end
    end
  end

  def destroy; end

  def update; end

  private

  def check_login
    return if @fail

    return if logged_in?

    @fail = t ".please_log_in"
  end

  def preprocess_and_save
    check_login
    load_rating
    load_subpitch
    allow_user_booked_and_owner
    return if @fail

    @comment = current_user.comments.build comment_params
    @fail = @comment.errors.full_messages.first unless @comment.save
  end

  def comment_params
    params.require(:comment).permit Comment::ALLOW_PARAMS
  end

  def allow_user_booked_and_owner
    return if @fail

    @user_booked = @rating.booking.user
    @owner = @subpitch.pitch.user
    return if current_user?(@user_booked) || current_user?(@owner)

    @fail = t ".not_allow"
  end

  def load_rating
    return if @fail

    @rating = Rating.find_by id: comment_params[:rating_id]
    return if @rating

    @fail = t ".not_found_rating_id"
  end

  def load_subpitch
    return if @fail

    @subpitch = @rating.subpitch
  end

  def load_author_comment
    @user = User.find_by id: @comment.user_id
  end

  def load_comment
    @comment = Comment.find_by id: params[:comment][:id]
    return if @comment

    flash[:danger] = t ".not_found_comment"
    redirect_to root_path
  end
end
