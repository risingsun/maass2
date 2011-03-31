class ForumTopic < ActiveRecord::Base
  
  validates :title, :presence => true

  belongs_to :forum
  belongs_to :owner, :class_name => "Profile"

  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id", :dependent => :destroy

end
