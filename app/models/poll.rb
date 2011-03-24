class Poll < ActiveRecord::Base
  
  OPT_HEIGHT = 35
  LABEL_WIDTH = 13
  GOOGLE_CHART_URL = "http://chart.apis.google.com/chart?"

  before_save :is_valid_question?
  
  belongs_to :profile
  has_many :poll_options, :dependent => :destroy
  has_many :poll_responses, :dependent => :destroy
  validates :question, :presence => true

  scope :public , :conditions => ["public = ?", true]
  scope :open_polls , :conditions => ["status = ?", true]
  
  accepts_nested_attributes_for :poll_options, :allow_destroy=> true , :reject_if=> proc{|attr| attr['option'].blank?}
  accepts_nested_attributes_for :poll_responses, :allow_destroy=> true

  include UserFeeds
  after_create :create_my_feed
  after_create :create_other_feeds

  def select_poll_options
    option_array = []
    poll_options.each do |p|
      option_array << [p.option,[p.id,p.poll_id]]
    end
    option_array
  end

  def responded?(profile)
    !self.poll_responses.find_by_profile_id(profile.id).nil? || self.status == false
  end

  def can_edit?
    self.votes_count < 1
  end
  
  def poll_close?
    self.status == false
  end
  
  def options_in_count_asc
    self.poll_options.find(:all,:order => "poll_responses_count ASC")
  end

  def graph_data_in_count_desc
    self.poll_options.find(:all,:order => "poll_responses_count DESC")
  end

  def get_url
    GOOGLE_CHART_URL + (['cht=bhg',data_at_y,graph_dim,graph_data,label_text,colours].join('&'))
  end
  
  private

  def is_valid_question?
    if self.poll_options.blank?
      errors.add(:question,"Please give at least one option.")
      return false
    end
  end

  def graph_data
    'chd=t:'+self.options_in_count_asc.map(&:votes_percentage).join(',')
  end

  def label_text(label_width=LABEL_WIDTH)
    chm=[]
    self.options_in_count_asc.each_with_index do |o ,i|
      chm << "t #{o.votes_percentage}%,000000,0,#{i},#{label_width}"
    end
    return 'chm='+chm.join('|')
  end

  def data_at_y
    'chxt=y&chxl=0:|'+(self.graph_data_in_count_desc.map(&:option).join('|'))
  end

  def graph_dim(width=500,per_option_height=OPT_HEIGHT)
    "chs=#{width}x#{self.poll_options.count*per_option_height}"
  end

  def colours
    "chco=#{GOOGLE_CHART_COLOUR_ARRAY.join('|')}"
  end

end