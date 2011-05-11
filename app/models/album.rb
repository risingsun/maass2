class Album < ActiveRecord::Base

  validates :name, :presence => true
  belongs_to :profile
  has_many :photos, :dependent => :destroy
  accepts_nested_attributes_for :photos, :allow_destroy => true

  def self.check_album(name)
    find_by_name(name)
  end

end