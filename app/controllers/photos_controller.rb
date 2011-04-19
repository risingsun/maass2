class PhotosController < ApplicationController

  layout "admin"

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
end