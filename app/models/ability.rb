class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    can :manage, List, :user_id => user.id
    can :read, List do |list|
      list.user_ids.include?(user.id)
    end
  end


end
