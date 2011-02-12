class Blog < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :profile
  validates :title, :presence => true
  validates :body, :presence => true
end
