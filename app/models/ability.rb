class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can %i(show update), User, id: user.id
    case user.role
    when "admin"
      can %i(read create destroy), User
      can :manage, [SubpitchType, Subpitch, Booking, Rating, Pitch, Recharge]
    when "owner"
      cannot :manage, User
      can :manage, Pitch, user_id: user.id
      can :manage, Subpitch, pitch: {user_id: user.id}
      can :manage, Booking, subpitch: {pitch: {user_id: user.id}}
      can :manage, Rating, booking: {subpitch: {pitch: {user_id: user.id}}}
    when "user"
      cannot :manage, :all
    end
  end
end
