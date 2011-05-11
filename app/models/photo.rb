class Photo < ActiveRecord::Base

  require "open-uri"

  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  belongs_to :album
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :image, :styles  => {:thumbnail=>"100x100>", :original => "975x800>" }, :processors => [:cropper], :default_url => "/images/image_missing.png"
  after_update :reprocess_avatar, :if => :cropping?
  accepts_nested_attributes_for :album

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def self.get_photosets(user)
    auth= user.authentications.where(:provider => 'facebook').first
    return auth.blank? ? '' : FbGraph::User.fetch(auth.uid, :access_token => auth.access_token).albums
  end

  def photo_from_url(url)
     self.image=open(url)
  end

  def url_for_size(size = 'original')
    image.url(size)
  end

  private

  def reprocess_avatar
    image.reprocess!
  end

end
