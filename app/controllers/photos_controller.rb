class PhotosController < ApplicationController

  layout "admin"

  def new
    @album = Album.find(params[:album_id])
    @photo = @album.photos.new
  end
  def create
    @album = Album.find(params[:album_id])
    @photo = @album.photos.build(params[:photo])
    if @photo.save
        render :json => { :pic_path => @photo.image.url.to_s , :name => @photo.image.instance.attributes["image_file_name"] }, :content_type => 'text/html'
      else
        render :json => { :pic_path => "/images/image_missing.png" , :name => "Undefine Format Of Photo" }, :content_type => 'text/html'
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

  def show
    debugger
  end

  private

  def allow_to
    super :admin, :all => true
  end

end