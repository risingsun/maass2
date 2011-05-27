class PhotosController < ApplicationController  
  
  before_filter :load_album, :except => [:new, :create]

  layout "admin"

  def new
    @album = Album.find(params[:album_id])
    @photo = @album.photos.build
  end
  
  def create
    @album = Album.find(params[:album_id])
    @photo = @album.photos.new(params[:photo])
    if @photo.save
      flash[:notice] = "Successfully created image."
      redirect_to album_path(@album)
    else
      flash[:error] = "Image was not succesfully created"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated image."
      redirect_to album_path(@album)
    else
      flash[:error] = "Image was not succesfully updated"
      render 'edit'
    end
  end
  
  def destroy
    @photo.destroy
    redirect_to album_path(@album)
  end

  private

  def load_album
    @album = Album.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
  end
  
end