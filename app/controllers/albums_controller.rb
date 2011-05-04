class AlbumsController < ApplicationController

  layout "admin"

  before_filter :load_album, :only => [:edit, :update, :show, :destroy]

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

  def create
    @album= @p.albums.build(params[:album])
    if @album.save
      redirect_to new_album_photo_path(@album)
    else
      render :new
    end
  end

  def edit
    @title = "Update #{@album.name}"
    redirect_to new_album_photo_path(@album)
  end

  def update
    if @album.update_attributes(params[:album])
      flash[:notice] = "Successfully updated album."
      redirect_to albums_path(@album)
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

  private

  def allow_to
    super :admin, :all => true
  end

  def load_album
    @album = Album.find(params[:id])
  end

end