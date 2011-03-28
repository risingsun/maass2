class PhotosController < ApplicationController

  before_filter :hide_side_panels
  before_filter :blurb_image, :only => [:index, :new]

  def index
    @photos = @p.admin_images(@blurb_image)
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
  
  def edit
    @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated user."
      redirect_to profile_photos_path(@p)
    else
      render :action => 'edit'
    end
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
   @blurb_image = params[:blurb_image].eql?("true")
   @title = @blurb_image == "true" ? "Blurb Image" : "Image"
 end

end
