module EventsHelper
  def checked?(p_role, f_role )
    (p_role.eql?("Organizer") && f_role.eql?("Attending")) or (p_role.eql?(f_role))
  end

  def check_permission?(event)
    @p && event.is_organizer?(@p)
  end
end
