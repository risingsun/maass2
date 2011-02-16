class Photo < ActiveRecord::Base
  has_many :comments, :attributes => true
  belongs_to :camera
end
