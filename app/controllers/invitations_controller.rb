class InvitationsController < ApplicationController

  before_filter :show_panels
  before_filter :load_profile

  def index
    redirect_to new_profile_invitation_path
  end

  def new
    @invitation = Invitation.new(:profile_id => @profile)
  end

  def create
    respond_to do |format|
      format.html do
        @invites = []
        params[:invitation][:emails].split(%r{,\s*}).each do |e|
          e.gsub!(/\s*/,'')
          i = Invitation.find_or_initialize_by_email_and_profile_id(e,@profile.id)
          raise Exception.new(i.errors) if !i.valid?
          i.save
          @invites << i
        end
        raise Exception.new("No Emails found") if @invites.blank?
      end
    end
  rescue Exception => e
    flash.now[:error] = 'Seem like there was an error sending your invites'
    @invitation = Invitation.new(:emails => params[:invitation][:emails])
    @error = e.to_s
    render 'new'
  end

  private

  def load_profile
    @profile = params[:profile_id].to_i == @p.id ? @p : Profile[params[:profile_id]]
    @user = @profile.user
  end

  def show_panels
    @show_profile_side_panel = true
  end
  
end