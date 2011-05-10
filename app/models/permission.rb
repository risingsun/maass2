class Permission < ActiveRecord::Base

  MYSELF = "Myself"
  FRIENDS = "Friends"
  EVERYONE = "Everyone"
  DEFAULT_PERMISSIONS = [MYSELF,FRIENDS,EVERYONE]

  belongs_to :profile

  def field_name
    permission_field.to_s.titleize
  end

  DEFAULT_PERMISSIONS.each do |p|
    define_method("#{p.downcase}?") do
      permission_type == p
    end
  end

end
