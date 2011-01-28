class ProfilesController < ApplicationController

  def create
    @profile =  current_user.profile || current_user.build_profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build
    if @profile.save
      flash[:notice] = "Profile created."
      redirect_to :edit
    else
      render 'edit'
    end
  end

  def edit
     @map = initialize_map()
    @map.zoom = :bound
    @icon_org = Cartographer::Gicon.new(:name => "org",
          :image_url => '/images/marker.png',
          :shadow_url => '/images/marker.png',
          :width => 32,
          :height => 23,
          :shadow_width => 32,
          :shadow_height => 23,
          :anchor_x => 0,
          :anchor_y => 20,
          :info_anchor_x => 5,
          :info_anchor_y => 1)
    # Add the icons to map
    @map.icons <<  @icon_org
    @marker2 = Cartographer::Gmarker.new(:name=> "org12", :marker_type => "Organization",
              :position => [28.614309,77.201353],
              :info_window_url => "/welcome/sample_ajax",
              :icon => @icon_org)
    @map.markers << @marker2
    @profile =  current_user.profile || current_user.build_profile
    @educations = @profile.educations || @profile.educations.build
    @works = @profile.works || @profile.works.build

  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes!(params[:profile])
      flash[:notice] = "Profile updated."
      redirect_to :edit
    else
      flash[:notice] = "ERROR"
      render 'edit'
    end
  end

   private
  def initialize_map
     @map = Cartographer::Gmap.new( 'map' )
     @map.controls << :type
     @map.controls << :large
     @map.controls << :scale
     @map.controls << :overview
     @map.debug = false
     @map.marker_mgr = false
     @map.marker_clusterer = true

     cluster_icons = []


     org = Cartographer::ClusterIcon.new({:marker_type => "Organization"})
      org << {
                  :url => '/images/marker.png',
                  :height => 73,
                   :width => 118,
                  :opt_anchor => [10, 0],
                  :opt_textColor => 'black'
                }
         #push second variant
      org << {
                  :url => '/images/marker.png',
                  :height => 73,
                  :width => 118,
                  :opt_anchor => [20, 0],
                  :opt_textColor => 'black'
                }

        #push third variant
       org << {
                  :url => '/images/marker.png',
                  :height => 73,
                  :width => 118,
                  :opt_anchor => [26, 0],
                  :opt_textColor => 'black'
              }
      cluster_icons << org
     @map.marker_clusterer_icons = cluster_icons
     return @map
   end

end