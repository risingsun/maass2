class Blog < ActiveRecord::Base
   acts_as_taggable

   belongs_to :profile
end
