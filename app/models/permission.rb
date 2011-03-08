class Permission < ActiveRecord::Base

  DEFAULT_PERMISSIONS = ["Myself", "Friends", "Everyone"]

  belongs_to :profile

  def everyone?
    permission_type == "Everyone"
  end

  def myself?
    permission_type == "Myself"
  end

  def friends?
    permission_type == "Friends"
  end

end
