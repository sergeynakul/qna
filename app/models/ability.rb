# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscriber]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscriber], user_id: user.id
    can :best, Answer, question: { user_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { user_id: user.id }
    can :index, Reward
    can %i[vote_up vote_down], [Question, Answer]
    cannot %i[vote_up vote_down], [Question, Answer], user_id: user.id
  end
end
