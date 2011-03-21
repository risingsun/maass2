class Admin::HomeController < ApplicationController

  def index
    @profile = @p
  end
 
  def greetings
  end

  def admin
    @profile = @p
  end
end
