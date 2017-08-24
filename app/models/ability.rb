class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    can :manage, List, :user_id => user.id
    can :read, List do |list|
      list.user_ids.include?(user.id) or list.public == true
    end

    can :manage, Goal do |goal|
      goal.list.user_id == user.id
    end

    can :manage, :all if user.admin == true

    can :manage, List do |list|
      list.user_ids.include?(user.id) or user.admin == true
    end
    
  end


end
