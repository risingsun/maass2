class Blog < ActiveRecord::Base
  #  acts_as_commentable
  acts_as_taggable_on :tags

  belongs_to :profile
  has_many :comments, :as => :commentable

  scope :by_month_year,
    lambda {|month,year| {:conditions => ["monthname(created_at)=? and year(created_at)=?",month,year]}}

  validates :title, :presence => true
  validates :body, :presence => true

  after_create :create_my_feed

  define_index do
    indexes :title
    indexes :body
  end

   def create_my_feed
        self.feed_items.create(:item => self) 
   end

  def self.blog_groups
    find(:all,
      :select => "count(*) as cnt, MONTHNAME(created_at) as month,YEAR(created_at) as year" ,
      :group => "month,year",
      :order => "year DESC, MONTH(created_at) DESC" )
  end

end