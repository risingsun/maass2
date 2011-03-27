module EventsHelper
  def checked?(event, role)
    if event.role.eql?("Organizer") && role.eql?("Attending")
      return true
    else
      if event.role.eql?(role)
        return true
      else
        return false
      end
    end
  end
end
