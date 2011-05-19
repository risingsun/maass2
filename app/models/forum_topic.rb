class ForumTopic < ActiveRecord::Base
  
  belongs_to :forum
  belongs_to :owner, :class_name => "Profile"
  has_many :posts, :class_name => "ForumPost", :foreign_key => "topic_id", :dependent => :destroy
  validates :title, :presence => true, :length => { :maximum => 20 }
  
end
