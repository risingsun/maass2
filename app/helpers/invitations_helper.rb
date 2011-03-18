module InvitationsHelper

  def msg_profile_block
    str = ""
    @invites.each do |i|
      str += "<p>" +
        case i.status
      when :already_existing
        "Profile with email #{i.email} already exists, Check out #{link_to i.profile.full_name, profile_path(i.profile)}"
      when :reinviting
        "Friend with #{i.email} has been reinvited"
      when :already_invited
        "Friend with #{i.email} has already been invited recently"
      else
        "Friend with #{i.email} invited on your behalf."
      end + "</p>"
    end
    str.html_safe
  end

end