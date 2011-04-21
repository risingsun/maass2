class SessionsController <  Devise::SessionsController

  def allow_to
    super :all, :all=>true
  end

end