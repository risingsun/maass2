class PhotosController < ApplicationController

  #before_filter :hide_side_panels
  before_filter :blurb_image, :only => [:index, :new]

  def index
    @photos = @p.photos.all
    if @photos.blank?
      redirect_to new_profile_photo_path(@p, :blurb_image => @blurb_image)
    end
  end
  def new
    @photo = Photo.new
    @photo.set_as_blurb = @blurb_image
  end

  def create
    @photo = @p.photos.build(params[:photo])
    @photo.save
    redirect_to profile_photos_path(@p)
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to profile_photos_path(@p)
  end

 private

 def hide_side_panels
   @hide_panels = true
 end

 def blurb_image
   @blurb_image = params[:blurb_image]
 end

end
