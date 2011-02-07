class Blog < ActiveRecord::Base
   belongs_to :profile
   acts_as_taggable
   validates :title, :presence => true
   validates :body, :presence => true
end
