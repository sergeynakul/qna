# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abiliries
    end
  end

  def guest_abiliries
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abiliries
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
  end
end
