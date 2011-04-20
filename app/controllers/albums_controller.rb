class AlbumsController < ApplicationController

  layout "admin"

  def index
    @albums = @p.albums
    if @albums.blank?
      redirect_to new_album_path
    end
  end

  def new
    @album = Album.new
    @photos = @album.photos.build 
  end

  def create
    @album= @p.albums.build(params[:album])
    @album.save
    redirect_to albums_path
  end

  def edit
    @album = Album.find(params[:id])
    @photos = @album.photos
    @title = "Update #{@ablum.name} album"
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params[:album])
      flash[:notice] = "Successfully updated album."
      redirect_to albums_path(@album)
    else
      flash[:notice] = "Album was not succesfully updated"
      render :action => 'edit'
    end
  end

  def show
    @album = Album.find(params[:id])
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    redirect_to albums_path
  end

  def facebook_album
    @a = Photo.get_photosets
    @albums = @a.map {|a| a.name if !Album.check_album(a.name)}
  end

  def facebook_album_photos
    @a = Photo.get_photosets
    @a.each do |a|
      @al= a if a.name.eql?(params[:name])
    end
    @album = @p.albums.new(:name => @al.name)
    @album.save
    @al.photos.count.times do |c|
      a=@album.photos.build()
      a.photo_from_url(@al.photos[c].source)
      a.save
    end
    redirect_to album_path(@album)
  end

  private

  def allow_to
    super :admin, :all => true
  end
  
end