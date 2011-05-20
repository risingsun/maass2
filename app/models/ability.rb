class Ability
  include CanCan::Ability

  ADMIN_ENTITIES = [Announcement, Event, SiteContent, Album, Feedback, Forum, ForumTopic, ForumPost, StudentCheck]

  def initialize(user)
    user ||= User.new    

    if user.role.eql?('admin')
      can [:index, :create, :update], Nomination do |nomination|        
        nomination.try(:profile) == user.profile
      end

      can :read, [Profile, Blog, Poll]
      can :active_user, [Profile]
      can :manage, [:preference, :home]
      
      can [:update, :edit_account, :user_friends, :update_email], Profile do |profile|
        profile.try(:user) ==  user
      end

      can [:update, :create, :destroy], Blog do |blog|
        blog.try(:profile) == user.profile
      end

      can [:update, :create, :destroy, :poll_close], Poll do |poll|
        poll.try(:profile) == user.profile
      end

      can [:create, :sent_messages], Message

      can [:read, :destroy, :reply_message, :delete_messages], Message do |message|
        message.try(:receiver) == user.profile || message.try(:sender) == user.profile
      end

      can :manage, ADMIN_ENTITIES

    elsif user.role.eql?('user') && user.profile.is_active

      can [:create, :update], Nomination do |nomination|
        nomination.try(:profile) == user.profile
      end

      can :read, [Blog, Poll]
      can :show, [Profile, Event]
      
      can [:update, :edit_account, :user_friends, :update_email], Profile do |profile|
        profile.try(:user) ==  user
      end

      can [:update, :create, :destroy], Blog do |blog|
        blog.try(:profile) == user.profile
      end

      can [:update, :create, :destroy, :poll_close], Poll do |poll|
        poll.try(:profile) == user.profile
      end

      can [:create, :sent_messages], Message
      
      can [:read, :destroy, :reply_message, :delete_messages], Message do |message|
        message.try(:receiver) == user.profile || message.try(:sender) == user.profile
      end
      
    end
  end
end