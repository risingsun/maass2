class Blog < ActiveRecord::Base
  acts_as_taggable_on :tags

  belongs_to :profile
  has_many :comments, :as => :commentable
  scope :by_month_year, lambda {|month,year| {:conditions => ["monthname(created_at)=? and year(created_at)=?",month,year]}}

  validates :title, :body, :presence => true

  include UserFeeds

  after_create :create_my_feed
  after_create :create_other_feeds

  define_index do
    indexes :title
    indexes :body
  end

  def self.blog_groups
    all(:select => "count(*) as cnt, MONTHNAME(created_at) as month,YEAR(created_at) as year" ,
        :group => "month,year",
        :order => "year DESC, MONTH(created_at) DESC" )
  end

  def sent_by
    profile.full_name
  end

  def commented_users(profile)
    comments.comments_without_self(profile).uniq
  end

end