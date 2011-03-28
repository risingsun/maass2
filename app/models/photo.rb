class Photo < ActiveRecord::Base

  belongs_to :profile
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  has_attached_file :image,
    :styles => { :original => "975x800>"}
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  #after_update :reprocess_avatar, :if => :cropping?

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  private

  def reprocess_avatar
    image.reprocess!
  end

end
