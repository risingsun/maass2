class Blog < ActiveRecord::Base
   acts_as_taggable
   belongs_to :profile
   validates :title, :presence => true
   validates :body, :presence => true
end
