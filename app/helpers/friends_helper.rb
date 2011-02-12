module FriendsHelper

  def user_find(profile_id)
    profile=Profile.find(profile_id)
    return User.find(profile.user_id)
  end
end
