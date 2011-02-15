class Blog < ActiveRecord::Base
  acts_as_taggable_on :tags
  belongs_to :profile
  validates :title, :presence => true
  validates :body, :presence => true

  def self.blog_groups
    find(:all,
         :select => "count(*) as cnt, MONTHNAME(created_at) as month,YEAR(created_at) as year" ,
         :group => "month,year",
         :order => "year DESC, MONTH(created_at) DESC" )
  end
end
