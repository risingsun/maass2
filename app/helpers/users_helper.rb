module UsersHelper
  def show_field(field_value,field_name,field)
    if (!field_value.blank? && @profile.can_see_field(field, @p)) || @p.is_me?(@profile)
      "<tr><th align='right'>#{field_name} </th><td>#{field_value}</td></tr>" 
    else
      ""
    end
  end
end