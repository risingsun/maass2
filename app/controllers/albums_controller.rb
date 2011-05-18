class AlbumsController < ApplicationController

  layout "admin"

  load_and_authorize_resource
  
  before_filter :load_album, :only => [:edit, :update, :show, :destroy, :upload_photo]

  def index
    @albums = @p.albums
    if @albums.blank?
      redirect_to new_album_path
    end
  end

  def new
    @album = @p.albums.create(:name => Date.current.strftime("%d %B %Y"))
    redirect_to new_album_photo_path(@album)
  end

  def edit
    @title = "Update #{@album.name}"
    redirect_to new_album_photo_path(@album)
  end

  def update
    if @album.update_attributes(params[:album])
      flash[:notice] = "Successfully updated album."
      redirect_to album_path(@album)
    else
      flash[:error] = "Album was not succesfully updated"
      render :edit
    end
  end

  def show
  end

  def destroy
    @album.destroy
    redirect_to albums_path
  end

  def facebook_album
    @a = Photo.get_photosets(current_user)
    @albums = @a.map {|a| a.name if !Album.check_album(a.name)}
  end

  def facebook_album_photos
    @a = Photo.get_photosets(current_user)
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

  def upload_photo
    @photo = @album.photos.new(params[:photo])
    if @photo.save
      render :json => { :thumbnail=> @photo.image.url(:thumbnail).to_s, :url => @photo.image.url, :id => @photo.id , :name => @photo.image.instance.attributes["image_file_name"] }
    else
      render :json => { :url => "/images/image_missing.png" , :name => "Undefine Format Of Photo" }
    end
  end

  private

  def load_album
    @album = Album.find(params[:id])
  end

end