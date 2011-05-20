class NominationsController < ApplicationController

  load_and_authorize_resource :profile
  load_and_authorize_resource :nomination, :through => :profile, :singleton => true  

  def index
    @nominations = Nomination.all
    render :layout => "admin"
  end
  
  def create    
    @nomination = @p.build_nomination(params[:nomination])
    if @nomination.save
      flash[:notice]= 'Nomination was successfully created.'
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def edit
    @nomination = Nomination.find(params[:id])
  end

  def update
    @nomination = Nomination.find(params[:id])
    if @nomination.update_attributes(params[:nomination])
      flash[:notice] = 'Nomination was successfully updated.'
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
end