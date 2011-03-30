class Forum < ActiveRecord::Base
  acts_as_list

  validates :name, :presence => true
  has_many :forum_topics, :class_name => "ForumTopic", :order => "updated_at DESC", :dependent => :destroy
end
