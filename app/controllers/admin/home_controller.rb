class Admin::HomeController < ApplicationController
  before_filter :hide_side_panels
  def index
    @profile = @p
  end
 
  def greetings
  end

  def admin
    @profile = @p
  end

  def blogs
  end

  private

  def hide_side_panels
    @hide_panels = true
  end
end
