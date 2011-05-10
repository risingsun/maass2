class ForumPost < ActiveRecord::Base

  validates :body, :presence => true
  
  belongs_to :owner, :class_name => "Profile"
  belongs_to :topic, :class_name => "ForumTopic"

  def by_me?(me)
    owner == me
  end

end
