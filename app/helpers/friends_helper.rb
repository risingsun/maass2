module FriendsHelper

  def user_find(profile_id)
    Profile.find(profile_id)
  end
end
