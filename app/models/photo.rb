class Photo < ActiveRecord::Base

  require "open-uri"
  
  belongs_to :album
  accepts_nested_attributes_for :album
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  has_attached_file :image, :styles  => {:thumbnail=>"100x100>", :original => "975x800>" }, :processors => [:cropper], :default_url => "/images/image_missing.png"

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def self.get_photosets(user, name = '')
    auth = user.check_authentication('facebook')
    if !auth.blank?
      if name.blank?
        return FbGraph::User.fetch(auth.uid, :access_token => URI.escape(auth.access_token)).albums
      else
        return FbGraph::User.fetch(auth.uid, :access_token => URI.escape(auth.access_token)).albums.find{|a| a.name.eql?(name)}
      end
    end
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
