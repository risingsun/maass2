class Album < ActiveRecord::Base

  validates :name, :presence => true
  belongs_to :profile
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true, :reject_if => proc { |attrs| attrs['image'].blank? }

  def self.check_album(name)
      Album.find_by_name(name)
  end

end