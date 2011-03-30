class ForumTopic < ActiveRecord::Base
  belongs_to :forum
  belongs_to :owner, :class_name => "Profile"
end
