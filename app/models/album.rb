class Album < ActiveRecord::Base

  belongs_to :profile
  has_many :photos, :dependent => :destroy
  validates :name, :presence => true
  accepts_nested_attributes_for :photos, :allow_destroy => true

  def self.check_album(name)
    find_by_name(name)
  end

  def self.create_facebook_photos_album(user,name)
    f_album = Photo.get_photosets(user, name)
    @album = user.albums.create(:name => f_album.name)
    f_album.photos.count.times do |c|
      a = @album.photos.build
      a.photo_from_url(@al.photos[c].source).create
    end
    return @album
  end

end