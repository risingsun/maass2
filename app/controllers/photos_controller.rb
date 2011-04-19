class PhotosController < ApplicationController

  before_filter :blurb_image, :only => [:index, :new]

  layout "admin"

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
    if @photo.save
      flash[:notice] = "Image was successfully created."
      redirect_to profile_photos_path(@p)
    else
      flash[:notice] = "Image was not successfully created."
      redirect_to :back
    end
  end

  def edit
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
  end

  def update
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated image."
      redirect_to album_path(@album)
    else
      flash[:notice] = "Image was not succesfully updated"
      render :action => 'edit'
    end
  end

  def destroy
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @photo.destroy
    redirect_to album_path(@album)
  end

 private

 def blurb_image
   @blurb_image = params[:blurb_image].eql?("true")
   @title = @blurb_image == "true" ? "Blurb Image" : "Image"
 end

end