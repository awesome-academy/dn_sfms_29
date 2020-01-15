module SubpitchesHelper
  def check_like subpitch
    Like.find_by subpitch_id: subpitch.id
  end

  def liked like
    Like.find_by id: like.id
  end

  def count_like subpitch
    Like.by_subpitch(subpitch.id).count(:id)
  end
end
