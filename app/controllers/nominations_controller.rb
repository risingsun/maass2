class NominationsController < ApplicationController

  before_filter :setup,  :except => [:index]
  
  def index
    @nominations=Nomination.all
    render :layout => "admin"
  end
  
  def create    
    @nomination=@p.build_nomination(params[:nomination])
    if @nomination.save
      flash[:notice]= 'Nomination was successfully created.'
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def edit
    @nomination=Nomination.find(params[:id])
  end

  def update
    @nomination=Nomination.find(params[:id])
    if @nomination.update_attributes(params[:nomination])
      flash[:notice]='Nomination was successfully updated.'
      redirect_to root_url
    else
      render 'edit'
    end
  end

  protected

  def allow_to
    super :owner, :all => true
    super :admin, :only => [:index]
  end

  def setup    
    @my_nomination = params[:profile_id].to_i == @p.id
    @profile = @my_nomination  ? @p : Profile.find(params[:profile_id])
  end
  
end