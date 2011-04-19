class Photo < ActiveRecord::Base

  require "open-uri"

  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  validates :image_file_name, :presence => true
  belongs_to :album
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :image, :styles  => { :original => "975x800>" }, :processors => [:cropper]
  after_update :reprocess_avatar, :if => :cropping?

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def self.blurb_images
    Photo.where(:set_as_blurb => true)
  end

  def self.get_photosets
    user = User.find{ |u| u.admin == true}
    auth= user.authentications.where(:provider => 'facebook').first
    return auth.blank? ? '' : FbGraph::User.fetch(auth.uid, :access_token => auth.access_token).albums
  end

  def photo_from_url(url)
     self.image=open(url)
  end


  private

  def reprocess_avatar
    image.reprocess!
  end

  def self.blurb_images
    Photo.where(:set_as_blurb => true)
  end

end
