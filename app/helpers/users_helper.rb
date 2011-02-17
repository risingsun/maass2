module UsersHelper
  def show_field(field_value,field_name,field)
    if !field_value.blank?
      "<tr><th align='right'>#{field_name} : </th><td>#{field_value}</td></tr>"
    else
      ""
    end
  end
end
