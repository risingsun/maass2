class Photo < ActiveRecord::Base

  belongs_to :profile

  has_attached_file :image,
    :styles => { :original => "975x800>"}
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']
end
