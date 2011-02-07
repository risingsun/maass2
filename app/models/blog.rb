class Blog < ActiveRecord::Base
   belongs_to :profile
   validates :title, :presence => true
   validates :body, :presence => true
end
