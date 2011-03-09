class Blog < ActiveRecord::Base
  #  acts_as_commentable
  acts_as_taggable_on :tags

  belongs_to :profile
  has_many :comments, :as => :commentable

  scope :by_month_year, lambda {|month,year| {:conditions => ["monthname(created_at)=? and year(created_at)=?",month,year]}}

  validates :title, :presence => true
  validates :body, :presence => true
  include UserFeeds
  #has_one :feed_item, :as => :commentable
  after_create :create_my_feed
  after_create :create_other_feeds

  #  def create_my_feed
  #    profile.feed_items.create(:item => self)
  #  end

  define_index do
    indexes :title
    indexes :body
  end
  
  def self.blog_groups
    find(:all,
      :select => "count(*) as cnt, MONTHNAME(created_at) as month,YEAR(created_at) as year" ,
      :group => "month,year",
      :order => "year DESC, MONTH(created_at) DESC" )
  end

  def self.comment_count(blog)
    #    debugger
    blog = Blog.find(blog)
    c = Comment.find(:all,:conditions => { :commentable_id => blog }).count
    blog.update_attributes(:comments_count => c )
  end
  
end