module EventsHelper
  def checked?(p_role, f_role )
    if p_role.eql?("Organizer") && f_role.eql?("Attending")
      return true
    else
      if p_role.eql?(f_role)
        return true
      else
        return false
      end
    end
  end

  def check_permission?(event)
    if @p && event.is_organizer?(@p)
      return true
    else
      return false
    end
  end
end
